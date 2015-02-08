# author: Ari Kalfus
# email: akalfus@brandeis.edu
# COSI 105B
# (PA) Movies Part 2

# Class loads and stores movie data.
# noinspection RubyInstanceMethodNamingConvention
class DataStorage

  attr_reader :user_movie_map, :movie_ratings_map

  def initialize
    @user_movie_map = Hash.new
    @movie_ratings_map = Hash.new
  end

  def get_user_IDs
    ids = @user_movie_map.keys
    verify_results ids
  end

  def get_movie_IDs
    ids = @movie_ratings_map.keys
    verify_results ids
  end

  # Returned as Hash of hashes from user id => rating
  def get_all_ratings(movie_id)
    ratings = @movie_ratings_map[movie_id]
    ratings.nil? ? Hash.new : ratings
  end

  # Returned as array of movie IDs
  def movies(user_id)
    movies = @user_movie_map[user_id]
    verify_results movies
  end

  # Get all users who have reviewed a certain movie
  def viewers(movie_id)
    ratings = get_all_ratings(movie_id)
    verify_results ratings, ratings.keys
  end

  # User reviews are stored as an array of movie id's per user id in a hash
  def add_user_review(user_id, movie_id)

    # Create user_id entry if id does not already exist in hash.
    @user_movie_map[user_id] = [] if @user_movie_map[user_id].nil?
    # Add movie id to list of movies reviewed
    @user_movie_map[user_id].push movie_id

  end

  # Movie ratings are stored as a hash from user id => rating per movie id in a larger hash
  def add_movie_rating(user_id, movie_id, rating)

    # Create movie_id entry if id does not already exist in hash
    @movie_ratings_map[movie_id] = Hash.new if @movie_ratings_map[movie_id].nil?

    # Add rating to list of reviews
    ratings = get_all_ratings movie_id
    ratings[user_id] = rating
    @movie_ratings_map[movie_id] = ratings

  end

  # Creates review mappings from lines in a data file.
  #
  # see #add_user_review and #add_movie_rating
  def load_data(file)

    file.each_line do |line|
      # data is stored in 4 chunks. [0] := user_id, [1] := movie_id, [2] := rating, [3] := timestamp
      # We ignore the timestamp
      review = line.chomp.split

      add_user_review review[0], review[1]
      add_movie_rating review[0], review[1], review[2]
    end

  end

  private

  def evaluate_nil?(element, nil_return, else_return)
    element.nil? ? nil_return : else_return
  end

  # Ensures IDs are not nil.
  def verify_results(result, to_return=result)
    evaluate_nil? result, ['0'], to_return
  end

end