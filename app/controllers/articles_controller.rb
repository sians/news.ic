class ArticlesController < ApplicationController
  def index
    @articles = policy_scope(current_user.articles).order(created_at: :desc)
  end

  def scrape_articles
    skip_authorization
    scraper = GuardianScrapeService.new
    @results = scraper.create_articles
    binding.pry
    redirect_to root_path

  end

end
