# Author:: Ari Kalfus
# Email:: akalfus@brandeis.edu
# COSI 105B
# (PA) Movies Part 2

require 'set'

class MovieTest

  # params is an array of hashes, each made up of :user_id, :movie_id, :rating, and :prediction
  def initialize(params)
    @data = params
    @errors = Set.new
    compute_errors
  end

  # Returns average prediction error
  def mean
    sum = @errors.inject { |sum, er| sum + er }

    sum.to_f / @errors.size

  end

  # Returns standard deviation of error
  def stddev
    Math.sqrt variance
  end

  # Returns root mean square error of a prediction
  def rms
    total = @errors.inject { |acc, er| acc + er**2 }

    Math.sqrt(total.to_f / @errors.size)

  end

  # Returns variance of error
  def variance

    mean_of_errors = mean
    sum = @errors.inject { |sum, er| sum + (er - mean_of_errors)**2 }

    sum.to_f / @errors.size

  end

  def to_a

    results = []
    @data.each do |result|
      results.push %W(#{result[:user_id]} #{result[:movie_id]} #{result[:rating].to_f} #{result[:prediction].to_f})
    end

    results

  end

  def compute_stats
    %Q(
    Mean: #{mean}
    RMS: #{rms}
    Standard deviation: #{stddev}
    )
  end


  private

  def compute_errors

    @data.each do |result|
      error = diff(result[:rating], result[:prediction])
      @errors.add error
    end

  end

  # Computes the difference between two numbers.
  def diff(num1, num2)
    (num1 - num2).abs
  end

end