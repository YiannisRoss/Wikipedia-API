# frozen_string_literal: true

module APIMethods
  require 'uri'
  require 'net/http'
  require 'json'

  def search(search_term, sroffset = 10, retrieved_articles = [])

    uri = URI("https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=#{search_term.body}&format=json&sroffset=#{sroffset}")
    response = Net::HTTP.get_response(uri)
    json_response = JSON.parse(response.body)

    json_response['query']['search'].each do |item|
      individual_uri = URI("https://en.wikipedia.org/w/api.php?action=query&prop=info&pageids=#{item['pageid']}&inprop=url&format=json")
      individual_response = Net::HTTP.get_response(individual_uri)
      extra_info = JSON.parse(individual_response.body)

      fullurl = extra_info['query']['pages'][item['pageid'].to_s]['fullurl']
      if search_complete?(retrieved_articles)
        return retrieved_articles
      else

        unless WikiEntry.any? { |entry| entry.pageid == item['pageid'].to_i }
          # in case the articles undergo changes during the search, or any other duplication incident

          retrieved_articles.push(WikiEntry.create(search_term_id: search_term.id, title: item['title'],
                                                   pageid: item['pageid'].to_i, wordcount: item['wordcount'], snippet: item['snippet'], fullurl: fullurl))
        end
      end
    end
  end

  def search_complete?(articles)
    articles.length >= 10
  end

  def sort(articles, by_wordcount, descending)
    articles = if by_wordcount
                 articles.sort_by(&:wordcount)
               else
                 articles.sort_by(&:title)
               end

    articles = articles.reverse if descending
    articles
  end

  def levenshtein_distance(s, t)
    m = s.length
    n = t.length
    return m if n.zero?
    return n if m.zero?

    d = Array.new(m + 1) { Array.new(n + 1) }

    (0..m).each { |i| d[i][0] = i }
    (0..n).each { |j| d[0][j] = j }
    (1..n).each do |j|
      (1..m).each do |i|
        d[i][j] = if s[i - 1] == t[j - 1]
                    d[i - 1][j - 1]
                  else
                    [d[i - 1][j] + 1,
                     d[i][j - 1] + 1,
                     d[i - 1][j - 1] + 1].min
                  end
      end
    end
    d[m][n]
  end
end
