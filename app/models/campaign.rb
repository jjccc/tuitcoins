class Campaign < ActiveRecord::Base
  attr_accessible :plan_id, :user_id, :period, :unity, :is_active, :is_default, :start_at, :impressions
  
  belongs_to :user
  belongs_to :plan
  
  before_create :default_values
  
  paginates_per 10
  
  def default_values
    self.is_active = false
    self.is_default = true
    self.impressions = 0
  end
  
  def ui_start_at
    self.start_at.nil? ? "" : self.start_at.strftime("%H:%M:%S")
  end
  
  def change_activation
    self.is_active ? self.activate : self.deactivate   
  end

  def activate
    # Debe crearse un delay_job con la periodicidad correspondiente a la campaña.
    if self.start_at.nil?
      # Si no se ha establecido hora de comienzo lanzamos la tarea dentro de 1 minuto
      run_at = DateTime.now + 1.minute
    else
      now = DateTime.now
      hour = self.start_at.hour
      minute = self.start_at.min
      second = self.start_at.sec
      run_at = DateTime.new(now.year, now.month, now.day, hour, minute, second)
      run_at += 1.day if run_at < DateTime.now
    end
    
    self.delay(:run_at => run_at).publish
  end
  
  def deactivate
    # Deben eliminarse los delay_jobs de la campaña.    
  end
  
  def publish
    # Tuitea la campaña en el timeline del usuario.
    TwitterAccess.new(self.user).update(self.plan.decorate.tweet)
    
    # Reprograma el siguiente tuit.
    self.delay(:run_at => DateTime.now + self.offset).publish
   
    # Incremente la cuenta de impresiones de la campaña.
    self.impressions += 1
    self.save
  end
  
  def offset
    units = ["minutes", "hours", "days", "weeks", "months", "years"]
    eval("#{self.period}.#{units[self.unity - 1]}")
  end
  
end
