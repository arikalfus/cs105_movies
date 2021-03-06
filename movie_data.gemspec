# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name		= "pa1.sh"
  spec.version		= '1.0'
  spec.authors		= ["Ari Kalfus"]
  spec.email		= ["akalfus@brandeis.edu"]
  spec.summary		= %q{MovieData and MovieTest classes}
  spec.description	= %q{class MovieData contains: load_data, popularity(movie_id), popularity_list, similarity(user1, user2), most_similar(u) methods.}
  spec.homepage		= "N/A"
  spec.license		= "MIT"

  spec.files 		= ['lib/pa1.sh.rb']
  spec.executables	= ['bin/pa1.sh']
  spec.test_files	= ['tests/test_movie_data.rb']
  spec.require_paths	= ["lib"]
end
