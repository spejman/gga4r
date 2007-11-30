require File.dirname(__FILE__) + '/test_helper.rb'

class IndividualStub < Array
  def recombine(a)
    self * 2
  end
  def self.create_random_population(num_population = 30)
    population = []
    num_population.times do
      population << IndividualStub.new
    end
    return population
  end
end

class Gga4rTest < Test::Unit::TestCase

  def setup
  end
  
  def test_truth
    assert true
  end
  
  def test_recombine
    first_pop_even = IndividualStub.create_random_population(30)
    ga = GeneticAlgorithm.new(first_pop_even)
    new_pop = ga.recombination!
    assert true, first_pop_even.size < new_pop.size
    
    first_pop_odd = IndividualStub.create_random_population(31)
    ga = GeneticAlgorithm.new(first_pop_odd)
    new_pop = ga.recombination!
    assert true, first_pop_odd.size < new_pop.size
    
  end
end
