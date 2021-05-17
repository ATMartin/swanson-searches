class SearchesController < ApplicationController
  before_action :load_search, only: [:show]

  def index
    @searches = Search.all
    render json: @searches
  end

  def show
    render json: @search
  end

  def create
    unless @search = Search.find_by(query: params[:query])
      search_response = search_service.search(query: params[:query])
      @search = Search.create(query: params[:query], quotes: search_response)
    end

    render json: @search
  end

  private

  def load_search
    @search = Search.find(params[:id])
  end

  def search_service
    @search_service ||= SwansonApi::Search.new
  end
end
