# news.ic

# a user can search for headlines containing a keyword
# a user can see the top 3 words that appear more than once in conjunction with a keyword
# a user can

require 'nokogiri'
require 'open-uri'
require 'pry-byebug'

class GuardianScrapeService
  def initialize()
    @base_url = "https://www.theguardian.com/uk"
    # list of section names to I G N O R E - used in find_section_names
    @noise = ["securedrop", "Tip us off", "Culture Treat", "Video", "Documentaries", "Most viewed", "Letters treat"]
  end

  def create_articles
    articles = extract_article_details
    results = []
    articles.each do |article|
      # check if url is already in db & only add if new article
      unless Article.find_by(url: article[:url])
        a = Article.new(article)
        a.save
        results << a
      end
    end
    results
  end

  def extract_article_details
    section_headlines = find_articles_by_section(fetch_page)
    articles = []
    section_headlines.each do |section|
      section[1].each do |element|
        article = {}
        article[:section] = section[0]
        article[:url] = element[0]
        article[:date] = Date.today
        if element[1].size > 1
          article[:tag] = element[1][0] if element[1][0]
          article[:headline] = element[1][1]
        else
          article[:headline] = element[1][0]
        end
        articles << article
      end
    end
    articles
    # article = {
    #   headline: "",
    #   tag: "",
    #   section: "",
    #   url: "",
    #   date: DateTime.now(),
    #   most_commented: false,
    #   most_shared: false,
    #   most_viewed: false,
    #   most_viewed_ranking: nil
    # }
  end

  def find_articles_by_section(document)
    sections = find_section_names(document)
    section_headlines = {}
    nokogiri_sections = sections.map do |section|
      section_content = document.search("div[data-title='#{section}']")
      if section_content.first
        articles = {}
        section_content.first.search("a").each do |text|
          url = text["href"]
          if articles[url].nil?
            articles[url] = text.text.strip.split("  ")
          else
            articles[url] << text.text.strip
          end
          articles[url].uniq!
        end
        section_headlines[section] = articles unless articles.empty?
      end
    end
    section_headlines.uniq
  end

  # return an array of categories
  def find_section_names(document)
    sections = document.search(".fc-container__header__title")
    tidy_sections = sections.map do |section|
      tidy_section = section.text.strip.split("\n").first
    end
    @noise.each { |word| tidy_sections.delete(word) if tidy_sections.include? word }
    tidy_sections
  end

  def fetch_most_viewed(document)
    top_10 = document.search(".most-popular li")

    binding.pry

  end

  def fetch_page
    raw_html = open(@base_url).read
    document = Nokogiri::HTML(raw_html)
  end

end
