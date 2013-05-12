class RecipesController < ApplicationController
  respond_to :json

  def index
    @recipes = model_class.all
    respond_with @recipes
  end

  def show
    @recipe = model_class.find(params[:id])
    respond_with @recipe
  end
end
