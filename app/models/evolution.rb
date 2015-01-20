class Evolution

  attr_accessor :daily_ocurrences, :accumulated_ocurrences, :followers, :days
  
  
  def initialize(range)
    self.days = []
    self.daily_ocurrences = {}
    self.accumulated_ocurrences = {}
    self.followers = {}
    
    zone = ActiveSupport::TimeZone.new("Madrid")
    origin_date = Time.now.in_time_zone(zone).beginning_of_day - (range - 1).days
    counts = User.where("created_at >= ?", origin_date).group("date_trunc('day', created_at)").count
    
    accumulated = 0
    
    range.times do |i|
      date_key = (origin_date + i.days).strftime("%Y-%m-%d 00:00:00")
      ocurrences = counts[date_key] || 0
      self.days << (origin_date + i.days).strftime("%d/%m")
      self.daily_ocurrences[(origin_date + i.days).strftime("%d/%m")] = ocurrences
      self.accumulated_ocurrences[(origin_date + i.days).strftime("%d/%m")] = ocurrences + accumulated
      self.followers[(origin_date + i.days).strftime("%d/%m")] = User.where("created_at >= ?", origin_date).
                                                                      where("created_at < ?", origin_date + (i + 1).days).
                                                                      sum(:followers)
      accumulated += ocurrences
    end
  end
    
end

