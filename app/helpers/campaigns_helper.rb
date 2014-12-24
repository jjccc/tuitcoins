module CampaignsHelper

  def campaigns_label(count)
    count == 1 ? "campaña" : "campañas"
  end
  
  def status_label(is_active)
    is_active ? "Activa" : "Inactiva"
  end
  
  def status_class(is_active)
    is_active ? "btn-success" : "btn-danger"
  end
end
