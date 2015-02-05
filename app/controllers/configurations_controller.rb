class ConfigurationsController < ApplicationController

  # PUT /configurations/1
  def update
    @configuration = ::Configuration.find(params[:id])

    respond_to do |format|
      if @configuration.update_attributes(params[:configuration])
        format.html { redirect_to root_path, notice: 'Configuración modificada correctamente.' }
      else
        format.html { render action: "edit" }
      end
    end
  end
  
  # GET /configurations/1/edit
  def edit
    @configuration = ::Configuration.find(params[:id])
    @form_path = configuration_path(@configuration.id, :method => :put)
  end
  
end
