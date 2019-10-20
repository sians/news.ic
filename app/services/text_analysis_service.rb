class TextAnalysisService
  def initialize
    @noise = "in is of at a as the it be that for of by on to and if you was into who his amid yet we why are so with my how up from - have"
  end

  def top_freq_by_word(num, word_hash)
    word_hash.to_a.sort{|x,y| y[1] <=> x[1]}[0..num].to_h
  end

  # hash by frequency key, array of word occurances with that frequency
  def top_5_freq_by_freq(word_hash)
    result = {}
    word_hash.each do |word|
      if result[word[1]].nil?
        result[word[1]] = [word[0]]
      else
        result[word[1]] << word[0]
      end
    end
    result
  end

  def daily_word_frequency
    articles = Article.where(date: Date.today)
    calculate_word_frequency(articles)
  end

  def weekly_word_frequency
    articles = Article.where(date: 1.week.ago..Date.today)
    calculate_word_frequency(articles)
  end

  # returns array of articles that contain the name of a country
  def country_occurance(articles)
    countries = Wordset.find_by(title: "Countries")
    countries = countries[:set].downcase.gsub("--", " ").split(",")
    articles_with_country = []
    articles.each do |article|
      article.headline.downcase.split(" ").each do |word|
        articles_with_country << article if countries.include? word
      end
    end
    articles_with_country.uniq!
  end

  private

  def calculate_word_frequency(articles)
    word_frequency = Hash.new(0)
    articles.each do |article|
      article.headline.downcase.split(" ").each do |word|
        word_frequency[word] += 1 unless @noise.include? word
      end
    end
    word_frequency.reject! {|k,v| v < 2}
  end



  def city_occurance(articles)
  end

end
