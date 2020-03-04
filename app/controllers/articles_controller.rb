class ArticlesController < ApplicationController
  def index
    # @articles = policy_scope(current_user.articles).order(created_at: :desc)
    @articles = policy_scope(Article.all).order(created_at: :desc)
  end

  def show
    @article = Article.find(params[:id])
    authorize @article

    # render json: @article
    respond_to do |format|
      format.js
    end
  end

  def scrape_articles
    skip_authorization
    scraper = GuardianScrapeService.new
    @results = scraper.create_articles
    #binding.pry
    redirect_to root_path

  end



end
