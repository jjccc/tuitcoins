class Evolution

  attr_accessor :data
  
  def initialize(range)
    self.data = {}
    
    zone = ActiveSupport::TimeZone.new("Madrid")
    origin_date = Time.now.in_time_zone(zone).beginning_of_day - (range - 1).days
    counts = User.where("created_at >= ?", origin_date).group("date_trunc('day', created_at)").count
     
    range.times do |i|
      date_key = (origin_date + i.days).strftime("%Y-%m-%d 00:00:00")
      ocurrences = counts[date_key] || 0
      self.data[(origin_date + i.days).strftime("%d/%m")] = ocurrences
    end
  end
    
end

