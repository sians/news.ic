class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  # skip_before_action :check_signed_in, only: [:home]
  before_action :check_signed_in, except: [:home]

  def home
    @recent_articles = Article.order(created_at: :desc)[0..10]
    text_analyser = TextAnalysisService.new
    @wf = text_analyser.weekly_word_frequency
    top_20 = text_analyser.top_freq_by_word(20, @wf)
    @country_articles = text_analyser.country_occurance(Article.all)
    text_analyser.top_5_freq_by_freq(@wf)

  end

  private

  def check_signed_in
    redirect_to root_path(current_user) if signed_in?
  end
end
