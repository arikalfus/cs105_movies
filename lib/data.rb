class Data

  def initialize
    @user_movie_map = Hash.new
    @movie_ratings_map = Hash.new
  end

  def get_user_IDs
    @user_movie_map.keys
  end

  def get_movie_IDs
    @movie_ratings_map.keys
  end

  def get_all_ratings(movie_id)
    @movie_ratings_map[movie_id]
  end

  def get_all_movies_reviewed(user_id)
    @user_movie_map[user_id]
  end


end