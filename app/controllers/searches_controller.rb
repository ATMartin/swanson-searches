class SearchesController < ApplicationController
  before_action :load_search, only: [:show]

  def index
    @searches = Search.all
  end

  def show
  end

  def create
  end

  private

  def load_search
    @search = Search.find(params[:id])
  end
end
