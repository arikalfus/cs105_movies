# Author:: Ari Kalfus
# Email:: akalfus@brandeis.edu
# COSI 105B
# (PA) Movies Part 2

require 'set'

require_relative 'data_storage'
require_relative 'movie_test'

# noinspection RubyInstanceMethodNamingConvention
class MovieData

  attr_reader :training_data, :test_data #TODO: For testing purposes only. Remove during final refactor.

  # If no test file is given, use default initialization.
  #
  #see #initialize_defaults, #initialize_with_test
  def initialize(params)
    @training_data = DataStorage.new

    params.key?(:test) ? initialize_with_test(params) : initialize_defaults(params)
  end

  # Get all user IDs in either training or test data.
  # #execute_from_set decides which procedure to evaluate
  def get_user_IDs(set=:training)
    execute_from_set set, proc { @training_data.get_user_IDs }, proc { @test_data.get_user_IDs }
  end

  # # Get all movie IDs in either training or test data.
  # #execute_from_set decides which procedure to evaluate
  def get_movie_IDs(set=:training)
    execute_from_set set, proc { @training_data.get_movie_IDs }, proc { @test_data.get_movie_IDs }
  end

  # Get all ratings of a certain movie in either training or test data.
  # Returned as array of hashes from user id => rating
  # #execute_from_set decides which procedure to evaluate
  def get_all_ratings(movie_id, set=:training)
    execute_from_set set, proc { @training_data.get_all_ratings(movie_id) }, proc { @test_data.get_all_ratings(movie_id) }
  end

  # Find specific movie rating. If user did not rate movie, returns 0.
  def rating(user_id, movie_id)

    all_ratings = get_all_ratings movie_id
    all_ratings[user_id].to_i || 0

  end

  # Get all movies reviewed by a certain user in either training or test data.
  # Returned as array of movie IDs
  # #execute_from_set decides which procedure to evaluate
  def movies(user_id, set=:training)
    execute_from_set set, proc { @training_data.movies(user_id) }, proc { @test_data.movies(user_id) }
  end

  # Get all users who have reviewed a certain movie in either training or test data.
  def viewers(movie_id, set=:training)
    execute_from_set set, proc { @training_data.viewers(movie_id) }, proc { @test_data.viewers(movie_id) }
  end

  # Creates review mappings from lines in a data file
  #
  # see DataStorage#add_user_review and DataStorage#add_movie_rating
  def load_data(set_file=@training_file)

    set_file = evaluate_file set_file if set_file.is_a? Symbol
    set_file == @training_file ? set = :training : set = :test

    execute_from_set set, proc { @training_data.load_data(set_file) }, proc { @test_data.load_data(set_file) }

  end

  # Computes popularity of a movie
  # Popularity is defined as the total number of ratings multiplied by average review of movie
  def popularity(movie_id)

    reviews = get_all_ratings movie_id
    ratings_sum = 0
    reviews.values.each { |rating| ratings_sum += rating.to_i}

    reviews.size * (ratings_sum / reviews.size)

  end

  # Generates a list of movie id's ordered by popularity
  #
  # see #popularity
  def popularity_list

    pop_list = []
    movies = get_movie_IDs
    movies.each do |id|
      pop = popularity id
      pop_list.push %W(#{pop} #{id})
    end
    # sort popularity list in descending order by popularity values
    pop_list.sort! { |a,b| b[0].to_i <=> a[0].to_i } #average nlogn, in-place
    pop_list

  end

  # Generate a number which indicates the similarity in movie preference between user1 and user2.
  # Higher number indicates greater movie similarity.
  # Similarity is defined as total value from similarity in movie comparison multiplied by fraction
  # of movies in common divided by smaller of the number of movies watched between user1 and user2.

  # Rounds similarity to two decimal places.
  #
  # see #compare_movies_seen
  def similarity(user1, user2)

    user1 = user1.to_s if user1.is_a? Fixnum
    user2 = user2.to_s if user2.is_a? Fixnum

    user1_movies = movies user1
    user2_movies = movies user2
    movies_in_common = user1_movies & user2_movies

    movies_in_common ? sim = compare_movies_seen(movies_in_common, user1, user2) : sim = 0

    (sim * (movies_in_common.size / %W(#{user1_movies.size} #{user2_movies.size}).min.to_f)).round 2

  end

  # Returns a list of users whose tastes are most similar to the tastes of u
  def most_similar(u)

    users = get_user_IDs - ["#{u}"] # remove user from list of user ID's to test
    sim_of_users = []
    # sort similarity list in descending order by similarity scores
    users.each { |id| sim_of_users.push [similarity(u, id), id] }
    sim_of_users.sort! { |a,b| b[0] <=> a[0] } # average nlogn, in place

    sim_of_users
    
  end

  # Computes similarity between two users' movies in common.
  # This similarity is defined as 5 points per movie, minus numerical difference
  # in ratings between each user's rating.
  #
  # see #rating
  def compare_movies_seen(movies, user1, user2)

    similarity = 0
    movies.each do |id|
      user1_rating = rating user1, id
      user2_rating = rating user2, id

      similarity += 5 - (user1_rating - user2_rating).abs
    end
    similarity

  end

  # Returns estimate of what a user would rate a movie between 1.0 and 5.0.
  # Estimation is calculated based on the rating similar users gave this movie.
  def predict(user_id, movie_id)

    similar_array = most_similar user_id
    similar_users = similar_array.collect { |_, user| user }
    users_seen_movie = viewers movie_id
    user_sample = similar_users & users_seen_movie

    relevant_ratings = relevant_ratings movie_id, user_sample
    ratings_from_sample = Set.new

    user_sample.each do |user|
      ratings_from_sample.add relevant_ratings[user]
    end

    ratings_from_sample.to_s

  end

  def run_test(k=@test_file.count)

    raise ArgumentError, 'Test Data does not exist.' unless instance_variable_defined? :@test_file

    lines_to_test = @test_file.first k
    results = []
    lines_to_test.each do |line|
      # [0] := user_id, [1] := movie_id, [2] := rating, [3] := timestamp
      line = line.chomp.split
      user_id, movie_id = line[0], line[1]

      results.push({ :user_id => user_id, :movie_id => movie_id, :rating => rating(user_id, movie_id), :prediction => predict(user_id, movie_id) })
    end

    MovieTest.new results

  end


  private

  # If set is training set, initiate training set function. else, initiate test set function
  def execute_from_set(set, training_method, test_method)
    set == :training ? training_method.call : test_method.call
  end

  # If no test file is given, use default training set 'u.data'
  def initialize_defaults(params)
    @training_file = File.new "#{params[:folder]}/u.data"
  end

  # If test file is supplied, create training set and test set based on test file.
  def initialize_with_test(params)

    training_file_name = "#{params[:test]}.base"
    test_file_name = "#{params[:test]}.test"

    @training_file = File.new "#{params[:folder]}/#{training_file_name}"
    @test_file = File.new "#{params[:folder]}/#{test_file_name}"
    @test_data = DataStorage.new

  end

  # Returns one of two File instance variables depending on the symbol passed as an argument.
  def evaluate_file(symbol)
    symbol == :test ? @test_file : @training_file
  end

  # Returns a 2D array containing [user_id. rating] of all the user IDs in the user pool
  def relevant_ratings(movie_id, user_pool)

    ratings = get_all_ratings movie_id
    relevant_ratings = []
    ratings.each { |user, rating| relevant_ratings.push user => rating if user_pool.include? user }

    relevant_ratings

  end

end