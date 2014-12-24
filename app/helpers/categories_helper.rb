module CategoriesHelper

  def categories_label(count)
    count == 1 ? "categoría" : "categorías"
  end
  
end
