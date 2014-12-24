module UsersHelper
  
  def users_label(count)
    count == 1 ? "usuario" : "usuarios"
  end
  
  def followers_label(count)
    count == 1 ? "seguidor" : "seguidores"
  end
  
end
