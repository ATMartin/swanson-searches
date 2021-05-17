class SearchesController < ApplicationController
  before_action :load_search, only: [:show]
  before_action :require_query, only: [:create]

  def index
    @searches = Search.all.order(query: :asc)

    if search_params[:filter]
      @searches = @searches.where("query ILIKE ?", "%#{search_params[:filter]}%")
    end

    if search_params[:sort] == "desc"
      @searches = @searches.reorder(query: :desc)
    end

    render json: @searches
  end

  def show
    render json: @search
  end

  def create
    status = :ok
    query = search_params[:query]

    unless @search = Search.find_by(query: query)
      search_response = search_service.search(query: query)
      @search = Search.create(query: query, quotes: search_response)
      status = :created
    end

    render json: @search, status: status
  rescue SwansonApi::Error => e
    render json: { error: e.message }, status: e.status
  end

  private

  def search_params
    params.permit(:sort, :filter, :query)
  end

  def load_search
    @search = Search.find(params[:id])
  end

  def require_query
    return if search_params[:query]

    render json: { error: "You must provide a 'query' key to run a search." }, status: :bad_request
  end

  def search_service
    @search_service ||= SwansonApi::Search.new
  end
end
