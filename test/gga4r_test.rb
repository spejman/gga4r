require File.dirname(__FILE__) + '/test_helper.rb'

class IndividualStub < Array

  def mutate
  end

  def fitness
  end

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
  def test_evolve
    first_pop_even = IndividualStub.create_random_population(30)
    ga = GeneticAlgorithm.new(first_pop_even)
    ga.evolve()
    new_pop = ga.instance_variable_get(:@population)

    assert first_pop_even.size < new_pop.size
  end
end
