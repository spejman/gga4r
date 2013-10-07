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
      population << IndividualStub.new([1,2,3])
    end
    return population
  end
end

class StringPopulation < Array
  def fitness
    fitness = self.select { |pos| pos == 1 }.size.to_f / self.size.to_f
    fitness
  end

  def recombine(c2)
    cross_point = rand([self.size, c2.size].min) + 1
    c1_a, c1_b = self.slice(0,cross_point), self.slice(cross_point, 0)
    c2_a, c2_b = c2.slice(0,cross_point), c2.slice(cross_point, 0)
    [StringPopulation.new(c1_a + c2_b), StringPopulation.new(c2_a + c1_b)]
  end

  def mutate
    mutate_point = (rand * self.size).to_i
    self[mutate_point] = 1
  end

  def self.create_population(s_long = 10, num = 10)
    population = []
    num.times  do
      chromosome = self.new(Array.new(s_long).collect { (rand > 0.2) ? 0:1 })
      population << chromosome
    end
    population
  end
end

class Gga4rTest < Test::Unit::TestCase
  def test_single_recombination_result
    first_pop_even = IndividualStub.create_random_population(30)
    ga = GeneticAlgorithm.new(first_pop_even)
    5.times do |i|
      ga.evolve
      new_pop = ga.instance_variable_get(:@population)
      assert first_pop_even.size < new_pop.size
    end
  end

  def test_multiple_recombination
    opts = {multi_recombination: true}
    ga = GeneticAlgorithm.new(StringPopulation.create_population, opts)
    assert ga.instance_variable_get(:@multi_recombination)
    4.times do |i|
      assert_nothing_raised do
        ga.evolve
      end
    end
  end
end
