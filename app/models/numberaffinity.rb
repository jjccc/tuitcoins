class Numberaffinity < App

  attr_reader :user_number, :followers, :affinity, :affined_followers
  
  def run(current_user)
    super(current_user)
    
    @user_number = calculate_user_number(current_user.name)
    @followers = Rails.env.development? ? retrieve_dummy_followers : retrieve_followers
    @position = calculate_position
    @affinity = distance(@followers.count + 1)
    @affined_followers = calculate_most_affined(10)
    @result_tweet = calculate_result_tweet    
  end
  
  private
  
  # Returns the sum of unicode values of user name's chars.
  def calculate_user_number(name)
    name.each_codepoint.reduce(:+) 
  end
  
  # Use Twitter's API to get the user's followers. For each follower, we calculate its user number.
  # Followers are sorted by value.
  def retrieve_followers
    followers_list = []
    
    begin
      @twitter_client.followers(@user.name).each do |follower|
        followers_list << TwitterUser.new(follower[:name], 
                                          follower[:screen_name], 
                                          follower[:profile_image_url], 
                                          calculate_user_number(follower[:screen_name]))
      end
    rescue Twitter::Error::TooManyRequests => error
      raise error.as_json.inspect
    end
    
    followers_list.sort{ |a, b| a.value <=> b.value }
  end
  
  # Use dummy followers for testing. For each follower, we calculate its user number.
  # Followers are sorted by value.
  def retrieve_dummy_followers
    followers_list = []
    
    dummies = [["Jaime Lopez Francos", "LopezFrancos", "http://abs.twimg.com/sticky/default_profile_images/default_profile_2_normal.png"],
               ["Gonzalo López", "gonzalolopez112", "http://abs.twimg.com/sticky/default_profile_images/default_profile_2_normal.png"],
               ["jmmartinezc", "juanmagician", "http://abs.twimg.com/sticky/default_profile_images/default_profile_2_normal.png"],
               ["Laura Gil", "tres_manchas", "http://abs.twimg.com/sticky/default_profile_images/default_profile_2_normal.png"]]
    
    begin
      dummies.each do |follower|
        followers_list << TwitterUser.new(follower[0], 
                                          follower[1], 
                                          follower[2], 
                                          calculate_user_number(follower[0]))
      end
    rescue Twitter::Error::TooManyRequests => error
      self.has_twitter_error = true
    end
    
    followers_list.sort{ |a, b| a.value <=> b.value }
  end
  
  def calculate_position
    @followers.each_with_index do |follower, i|
      if @user_number <= follower.value
        return i + 1
      end
    end
    @followers.count + 1
  end
  
  def distance(count)
    if count == 1
      100
    else
      if count.odd?
        middle = (count / 2) + 1
        distance_to_middle = (@position - middle).abs
        (100.0 - ((100.0 / (count / 2).to_f) * distance_to_middle.to_f)).round(1)
      else
        middle = (count / 2).to_f + 0.5
        distance_to_middle = (@position.to_f - middle).abs
        (100.0 - ((100.0 / (middle - 1.0).to_f) * distance_to_middle.to_f)).round(1)
      end
    end
  end
  
  def calculate_most_affined(count)
    range_min_position = @position - (count / 2)
    range_min_position = 1 if range_min_position < 1
    range_max_position = range_min_position + (count - 1)
    range_max_position = @followers.count if range_max_position > @followers.count
    
    @followers.blank? ? [] : @followers[(range_min_position - 1)..(range_max_position - 1)]
  end
  
  def calculate_result_tweet        
    tweet = ::Configuration.find_by_name("TUIT_TEXT").value
    
    # Reemplazamos las ocurrencias de {result} que son los valores que devuelve la aplicación.
    results = [@user_number.to_s, @affinity.to_s]    
    results.each{ |r| tweet.sub!("{result}", r) }
    
    # Reemplazamos las ocurrencias de {user} por followers del usuario.
    users_count = tweet.scan("{user}").count
    affined = calculate_most_affined(users_count)
    affined.each{ |a| tweet.sub!("{user}", "@#{a.nick}") }
    
    # Eliminamos los sobrantes si los followers son menores que los solicitados.
    tweet.gsub!("{user}", "")
        
    # Reemplazamos la ocurrencia de {url}
    tweet.sub!("{url}", "http://bit.ly/16J1IxC") 
    
    tweet
  end
  
end