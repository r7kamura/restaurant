module Restaurant::ModelClassFinder
  private

  def model_class
    self.class.name.sub(/Controller$/, "").singularize.constantize
  end
end
