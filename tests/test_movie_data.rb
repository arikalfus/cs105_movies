require './lib/movie_data.rb'
require 'test/unit'

class TestMovie < Test::Unit::TestCase

  def test_data_storage
    movie_data = MovieData.new :folder => './data/ml-100k'
    assert_not_nil movie_data.training_data, 'Training Data is nil!'
    assert_equal nil, movie_data.test_data, 'Test Data is not nil!'

    puts "Training data: #{movie_data.training_data}"
    puts "Test data: #{movie_data.test_data}"
  end

	def test_load_data
		movie_data = MovieData.new :folder => './data/ml-100k'
		movie_data.load_data
		assert_not_nil(movie_data.get_user_IDs)
		assert_not_nil(movie_data.get_movie_IDs)
	end

	def test_popularity
		movie_data = MovieData.new :folder => './data/ml-100k'
		movie_data.load_data
		movies = movie_data.get_movie_IDs
		movies.each do |movie|
			pop = movie_data.popularity movie
			assert_not_nil pop
		end
	end

	def test_popularity_list
		movie_data = MovieData.new :folder => './data/ml-100k'
		movie_data.load_data
		pop_list =  movie_data.popularity_list
		assert_not_nil pop_list
	end

	def test_similarity
		movie_data = MovieData.new :folder => './data/ml-100k'
		movie_data.load_data
		users = movie_data.get_user_IDs
		user1 = users[rand users.size]
		user2 = users[rand users.size]

		sim = movie_data.similarity user1, user2
		assert_not_equal 0, sim
	end

	def test_total_sim
		movie_data = MovieData.new :folder => './data/ml-100k'
		movie_data.load_data
		users = movie_data.get_user_IDs
		u = users[rand users.size]

		total_sim = movie_data.most_similar u
		i = 1
		puts 'Top 10 Most similar users:'
		puts "#{i}. Popularity: #{total_sim[0][0]}, user ID: #{total_sim[0][1]} (greatest similarity)"
		total_sim[1...10].each {|pop, id| puts "#{i += 1}. Popularity: #{pop}, user ID: #{id}"}
		i = 1
		puts "\nTop 10 Least similar users:"
		puts "#{i}. Popularity: #{total_sim.last[0]}, user ID: #{total_sim.last[1]} (least similarity)"
		total_sim.pop
		(1...10).each do
			sim_array = total_sim.pop
			puts "#{i += 1}. Popularity: #{sim_array[0]}, user ID: #{sim_array[1]}"
		end
	end
	
end