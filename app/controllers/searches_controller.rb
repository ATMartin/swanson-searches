class SearchesController < ApplicationController
  before_action :load_search, only: [:show]

  def index
    @searches = Search.all.order(query: :asc)

    if params[:filter]
      @searches = @searches.where("query ILIKE ?", "%#{params[:filter]}%")
    end

    if params[:sort] == "desc"
      @searches = @searches.reorder(query: :desc)
    end

    render json: @searches
  end

  def show
    render json: @search
  end

  def create
    status = :ok
    unless @search = Search.find_by(query: params[:query])
      search_response = search_service.search(query: params[:query])
      @search = Search.create(query: params[:query], quotes: search_response)
      status = :created
    end

    render json: @search, status: status
  end

  private

  def load_search
    @search = Search.find(params[:id])
  end

  def search_service
    @search_service ||= SwansonApi::Search.new
  end
end
