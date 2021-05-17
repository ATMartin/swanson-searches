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
  end

  private

  def load_search
    @search = Search.find(params[:id])
  end
end
