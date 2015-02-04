require '../lib/movie_data.rb'

def load_file(file)
  print 'Loading default movie data into system...'
  movie_data = MovieData.new(:file => file)
  movie_data.load_data
  puts "Done\n\n"

  movie_data
end

def print_popularity_list(movie_data)
  list = movie_data.popularity_list
  puts 'Top 10 Most Popular Movies'
  i = 0
  list[0...10].each { |pop, id| puts "#{i += 1}. Movie ID: #{id}, Popularity: #{pop}" }

  i = 0
  puts "\nTop 10 Least Popular Movies"
  list[-10..-1].reverse!.each { |pop, id| puts "#{i += 1}. Movie ID: #{id}, Popularity: #{pop}" }
  puts "\n"
end

def print_most_similar(movie_data)
  list = movie_data.most_similar 1
  puts 'Top 10 Most Similar Users'
  i = 0
  list[0...10].each { |sim, id| puts "#{i += 1}. User ID: #{id}, Similarity: #{sim}" }

  i = 0
  puts "\nTop 10 Least Similar Users"
  list[-10..-1].reverse!.each { |sim, id| puts "#{i += 1}. User ID: #{id}, Similarity: #{sim}" }
end

movie_data = load_file '../data/ml-100k'
print_popularity_list movie_data
puts "---------------------\n\n"
print_most_similar movie_data