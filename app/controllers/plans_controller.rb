class PlansController < ApplicationController
  
  # GET /plans
  def index
    @plans_count = Plan.all.count
    @paginable_plans = Plan.order(:name).page(params[:page])
    @plans = PlanDecorator.decorate_collection(@paginable_plans)
  end
  
  # GET /plans/new
  def new
    @plan = Plan.new
    @form_path = plans_path
    @categories = Category.order(:name)
  end
  
  # GET /plans/1/edit
  def edit
    @plan = Plan.find(params[:id])
    @form_path = plan_path(@plan.id, :method => :put)
    @categories = Category.order(:name)
  end

  # POST /plans
  def create
    @plan = Plan.new(params[:plan])

    respond_to do |format|
      if @plan.save
        format.html { redirect_to plans_path, notice: 'Plan creado correctamente.' }
      else
        format.html { render action: "new" }
      end
    end
  end
  
  # PUT /plans/1
  def update
    @plan = Plan.find(params[:id])

    respond_to do |format|
      if @plan.update_attributes(params[:plan])
        format.html { redirect_to plans_path, notice: 'Plan modificado correctamente.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /plans/1
  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to plans_path }
    end
  end
end
