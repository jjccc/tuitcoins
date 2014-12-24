class CategoriesController < ApplicationController
  
  # GET /categories
  def index
    @categories_count = Category.all.count
    @paginable_categories = Category.order(:name).page(params[:page])
    @categories = CategoryDecorator.decorate_collection(@paginable_categories)
  end
  
  # GET /categories/new
  def new
    @category = Category.new
    @form_path = categories_path
  end
  
  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    @form_path = category_path(@category.id, :method => :put)
  end

  # POST /categories
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'Categoría creada correctamente.' }
      else
        format.html { render action: "new" }
      end
    end
  end
  
  # PUT /categories/1
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to categories_path, notice: 'Categoría modificada correctamente.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /categories/1
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_path }
    end
  end
end
