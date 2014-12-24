class CampaignDecorator < Draper::Decorator
  delegate_all

  def plan_link
    object.plan.link
  end
  
  def plan_name
    object.plan.name
  end
  
  def category_name
    object.plan.category.name
  end
  
  def plan_tweet
    PlanDecorator.decorate(object.plan).tweet
  end
  
  def periodicity
    "Cada #{object.period} #{label_unities(object.period, object.unity)} #{label_start_at(object.start_at)}"
  end
  
  def impressions
    h.number_with_delimiter(object.impressions)
  end
  
  def impressions_label
    label = object.impressions == 1 ? "impresión" : "impresiones"
    "#{self.impressions} #{label}"
  end
  
  private
  
  def label_unities(period, unity)
    case unity
      when 1
        period == 1 ? "minuto" : "minutos"
      when 2
        period == 1 ? "hora" : "horas"
      when 3
        period == 1 ? "día" : "días"
      when 4
        period == 1 ? "semana" : "semanas"
      when 5
        period == 1 ? "mes" : "meses"
      when 6
        period == 1 ? "año" : "años"
    end
  end

  def label_start_at(start_at)
    start_at.nil? ? "" : "empezando a las #{start_at.strftime("%H:%M:%S")}"
  end
  
end
