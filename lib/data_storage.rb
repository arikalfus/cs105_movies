# author: Ari Kalfus
# email: akalfus@brandeis.edu
# COSI 105B
# (PA) Movies Part 2

# Class stores movie data.
class DataStorage

  attr_reader :user_movie_map, :movie_ratings_map

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

  # Returned as array of hashes from user id => rating
  def get_all_ratings(movie_id)
    @movie_ratings_map[movie_id]
  end

  # Returned as array of movie IDs
  def get_all_movies_reviewed(user_id)
    @user_movie_map[user_id]
  end

  def add_user_review(user_id, movie_id)

    # Create user_id entry if id does not already exist in hash.
    @user_movie_map[user_id] = [] if @user_movie_map[user_id].nil?
    # Add movie id to list of movies reviewed
    @user_movie_map[user_id].push movie_id

  end

  def add_movie_rating(user_id, movie_id, rating)

    # Create movie_id entry if id does not already exist in hash
    @movie_ratings_map[movie_id] = Hash.new if @movie_ratings_map[movie_id].nil?

    # Add rating to list of reviews
    ratings = get_all_ratings movie_id
    ratings[user_id] = rating
    @movie_ratings_map[movie_id] = ratings

  end


end