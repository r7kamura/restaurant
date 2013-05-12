class RecipesController < ApplicationController
  respond_to :json

  def index
    @recipes = Recipe.all
    respond_with @recipes
  end

  def show
    @recipe = Recipe.find(params[:id])
    respond_with @recipe
  end
end
