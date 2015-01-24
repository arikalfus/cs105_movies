# author: Ari Kalfus
# email: akalfus@brandeis.edu
# COSI 105B
# (PA) Movies Part 1

class MovieData

  # If no file is given, defaults to 'u.data' file in given folder
  def initialize(folder, file='u.data')
    @data = File.new "#{folder}/#{file}"
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
  def get__all_movies_reviewed(user_id)
    @user_movie_map[user_id]
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

  # Creates review mappings from lines in a data file
  #
  # see #add_user_review and #add_movie_rating
  def load_data

    @data.each_line do |line|
      # data is stored in 4 chunks. [0] := user_id, [1] := movie_id, [2] := rating, [3] := timestamp
      # We ignore the timestamp
      review = line.chomp.split
      add_user_review(review[0], review[1])
      add_movie_rating(review[0], review[1], review[2])
    end
    @data.close

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

    user1_movies = get__all_movies_reviewed user1
    user2_movies = get__all_movies_reviewed user2
    movies_in_common = user1_movies & user2_movies

    movies_in_common ? sim = compare_movies_seen(movies_in_common, user1, user2) : sim = 0

    (sim * (movies_in_common.size / %W(#{user1_movies.size} #{user2_movies.size}).min.to_f)).round 2

  end

  # Computes similarity between two users' movies in common.
  # This similarity is defined as 5 points per movie, minus numerical difference
  # in ratings between each user's rating.
  #
  # see #get_movie_rating
  def compare_movies_seen(movies, user1, user2)

    similarity = 0
    movies.each do |id|
      user1_rating = get_movie_rating id, user1
      user2_rating = get_movie_rating id, user2

      similarity += 5 - (user1_rating.to_i - user2_rating.to_i).abs
    end
    similarity

  end

  # Find specific movie rating.
  def get_movie_rating(movie_id, user_id)
    all_ratings = get_all_ratings movie_id
    all_ratings[user_id]
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

  # List private methods
  private :compare_movies_seen, :get_movie_rating

end