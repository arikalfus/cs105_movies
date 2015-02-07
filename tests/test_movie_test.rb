require './lib/movie_data.rb'
require './lib/movie_test.rb'
require 'test/unit'

class TestMovie < Test::Unit::TestCase

  def test_errors

    data = [{:user_id => 1, :movie_id => 1, :rating => 3, :prediction => 2.998},
            {:user_id => 2, :movie_id => 1, :rating => 2, :prediction => 2.998},
            {:user_id => 3, :movie_id => 1, :rating => 5, :prediction => 3.998},
            {:user_id => 4, :movie_id => 1, :rating => 1, :prediction => 1.734}]

    movie_test = MovieTest.new data

    assert_equal true, movie_test.errors.member?(3-2.998)
    assert_equal true, movie_test.errors.member?(2.998 - 2)
    assert_equal true, movie_test.errors.member?(5-3.998)
    assert_equal true, movie_test.errors.member?(1.734 - 1)

  end

  def test_mean

    data = [{:user_id => 1, :movie_id => 1, :rating => 3, :prediction => 2.998},
            {:user_id => 2, :movie_id => 1, :rating => 2, :prediction => 2.998},
            {:user_id => 3, :movie_id => 1, :rating => 5, :prediction => 3.998},
            {:user_id => 4, :movie_id => 1, :rating => 1, :prediction => 1.734}]

    movie_test = MovieTest.new data
    mean = movie_test.mean

    assert_equal 0.684, mean.round(3)

  end

  def test_rms

    data = [{:user_id => 1, :movie_id => 1, :rating => 3, :prediction => 2.998},
            {:user_id => 2, :movie_id => 1, :rating => 2, :prediction => 2.998},
            {:user_id => 3, :movie_id => 1, :rating => 5, :prediction => 3.998},
            {:user_id => 4, :movie_id => 1, :rating => 1, :prediction => 1.734}]

    movie_test = MovieTest.new data
    rms = movie_test.rms

    assert_equal 0.635191, rms.round(6)

  end

  def test_variance

    data = [{:user_id => 1, :movie_id => 1, :rating => 3, :prediction => 2.0},
            {:user_id => 2, :movie_id => 1, :rating => 2, :prediction => 1.0},
            {:user_id => 3, :movie_id => 1, :rating => 5, :prediction => 4.0},
            {:user_id => 4, :movie_id => 1, :rating => 1, :prediction => 2.0}]

    movie_test = MovieTest.new data
    variance = movie_test.variance

    assert_equal (19/12), variance

  end

  def test_stddev

    data = [{:user_id => 1, :movie_id => 1, :rating => 3, :prediction => 2.0},
            {:user_id => 2, :movie_id => 1, :rating => 2, :prediction => 1.0},
            {:user_id => 3, :movie_id => 1, :rating => 5, :prediction => 4.0},
            {:user_id => 4, :movie_id => 1, :rating => 1, :prediction => 2.0}]

    movie_test = MovieTest.new data
    stddev = movie_test.stddev

    assert_equal (Math.sqrt(19/3)/2), stddev

  end
	
end