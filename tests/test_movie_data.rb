require './lib/movie_data.rb'
require 'test/unit'

class TestMovie < Test::Unit::TestCase

	def test_load_data
		movie_data = MovieData.new folder: './data/ml-100k'
		movie_data.load_data
		assert_not_nil movie_data.get_user_IDs, "User ID's are nil!"
		assert_not_nil movie_data.get_movie_IDs, "Movie ID's are nil!"
	end

	def test_popularity
		movie_data = MovieData.new folder: './data/ml-100k'
		movie_data.load_data
		movies = movie_data.get_movie_IDs
		movies.each do |movie|
			pop = movie_data.popularity movie
			assert_not_nil pop, "#{movie}'s popularity is nil!"
		end
	end

	def test_popularity_list
		movie_data = MovieData.new folder: './data/ml-100k'
		movie_data.load_data
		pop_list =  movie_data.popularity_list
		assert_not_nil pop_list, 'Popularity list is nil!'
	end

	def test_similarity
		movie_data = MovieData.new folder: './data/ml-100k'
		movie_data.load_data
		users = movie_data.get_user_IDs
		user1 = users[rand users.size]
		user2 = users[rand users.size]

		sim = movie_data.similarity user1, user2
		assert_not_equal 0.0, sim, 'Similarity is 0! This does happen occasionally. Please rerun the rake test.'
	end

	# def test_total_sim
	# 	movie_data = MovieData.new folder: './data/ml-100k'
	# 	movie_data.load_data
	# 	users = movie_data.get_user_IDs
	# 	u = users[rand users.size]
  #
	# 	total_sim = movie_data.most_similar u
	# 	i = 1
	# 	puts 'Top 10 Most similar users:'
	# 	puts "#{i}. Popularity: #{total_sim[0][0]}, user ID: #{total_sim[0][1]} (greatest similarity)"
	# 	total_sim[1...10].each {|pop, id| puts "#{i += 1}. Popularity: #{pop}, user ID: #{id}"}
	# 	i = 1
	# 	puts "\nTop 10 Least similar users:"
	# 	puts "#{i}. Popularity: #{total_sim.last[0]}, user ID: #{total_sim.last[1]} (least similarity)"
	# 	total_sim.pop
	# 	(1...10).each do
	# 		sim_array = total_sim.pop
	# 		puts "#{i += 1}. Popularity: #{sim_array[0]}, user ID: #{sim_array[1]}"
	# 	end
	# end

  def test_prediction

    movie_data = MovieData.new(:folder => './data/ml-100k',
                               :test => :u1)

    movie_data.load_data
    users = movie_data.get_user_IDs
    test_users = movie_data.get_user_IDs(:test)
    movies = movie_data.get_movie_IDs
    test_movies = movie_data.get_movie_IDs(:test)

    sample_users = users & test_users
    sample_movies = movies & test_movies

    prediction = movie_data.predict rand(sample_users.size).to_s, rand(sample_movies.size).to_s

    puts "prediction: #{prediction}"

  end

  def test_run_test

    movie_data = MovieData.new(:folder => './data/ml-100k',
                               :test => :u1)

    movie_data.load_data
    movie_test = movie_data.run_test 100

    puts "Stats:\n#{movie_test.compute_stats}"
    assert movie_test.mean < 1.0

  end
	
end