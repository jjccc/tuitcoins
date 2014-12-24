class CampaignsController < ApplicationController
  
  # GET /campaigns
  def index
    @campaigns_count = Campaign.where(:is_default => true).count
    @paginable_campaigns = Campaign.where(:is_default => true).order(:start_at).page(params[:page])
    @campaigns = CampaignDecorator.decorate_collection(@paginable_campaigns)
  end

  # GET /campaigns/1
  def show
    @campaign = Campaign.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @campaign }
    end
  end

  # GET /campaigns/new
  def new
    @campaign = Campaign.new
    @form_path = campaigns_path
    @plans = Plan.order(:name)
    @unities = [Unity.new(1, "minutos"), Unity.new(2, "horas"), Unity.new(3, "días"), Unity.new(4, "semanas"), Unity.new(5, "meses"), Unity.new(6, "años")]
  end

  # GET /campaigns/1/edit
  def edit
    @campaign = Campaign.find(params[:id])
    @form_path = campaign_path(@campaign.id, :method => :put)
    @plans = Plan.order(:name)
    @unities = [Unity.new(1, "minutos"), Unity.new(2, "horas"), Unity.new(3, "días"), Unity.new(4, "semanas"), Unity.new(5, "meses"), Unity.new(6, "años")]
  end

  # POST /campaigns
  def create
    @campaign = Campaign.new(params[:campaign])

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to campaigns_path, notice: 'Campaña creada correctamente.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /campaigns/1
  def update
    @campaign = Campaign.find(params[:id])
 
    respond_to do |format|
      if params[:is_active].present?
        if @campaign.update_attributes(:is_active => params[:is_active] == "true")
          @campaign.change_activation
          format.html { redirect_to campaigns_path, notice: 'Campaña modificada correctamente.' }
        else
          format.html { render action: "edit" }
        end
      elsif @campaign.update_attributes(params[:campaign])
        format.html { redirect_to campaigns_path, notice: 'Campaña modificada correctamente.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /campaigns/1
  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy

    respond_to do |format|
      format.html { redirect_to campaigns_path }
    end
  end
end
