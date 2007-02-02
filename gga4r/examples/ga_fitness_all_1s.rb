require File.dirname(__FILE__) + '/../lib/ga4r'

class StringPopulation < Array
    def fitness
      self.select { |pos| pos == 1 }.size.to_f / self.size.to_f
    end

    def recombine(c2)
      cross_point = (rand * c2.size).to_i
      c1_a, c1_b = self.split(cross_point)
      c2_a, c2_b = c2.split(cross_point)
      [StringPopulation.new(c1_a + c2_b), StringPopulation.new(c2_a + c1_b)]
    end

    def mutate
      mutate_point = (rand * self.size).to_i
      self[mutate_point] = 1
    end

end

  def create_population_with_fit_all_1s(s_long = 10, num = 10)
    population = []
    num.times  do
      chromosome = StringPopulation.new(Array.new(s_long).collect { (rand > 0.2) ? 0:1 })
      population << chromosome
    end
    population
  end

ga = GeneticAlgorithm.new(create_population_with_fit_all_1s)

100.times { |i|
  ga.evolve
#  p ga.generations[-1]
  puts i
  best_fit = ga.best_fit
  puts "Num population: #{ga.generations[-1].size} - Generation: #{ga.num_generations}"
  puts "best fitness: #{best_fit[0].fitness} num fits: #{best_fit.size}"
  p ga.generations[-1]
  p best_fit[0]
  puts "mean fitness #{ga.mean_fitness} --> #{ga.mean_fitness(ga.num_generations)}"

#  p ga.generations[-1]
sum_fitness = 0
  ga.generations[-1].each { |chromosome| 
    sum_fitness += chromosome.fitness
  }

  tmp = sum_fitness.to_f / ga.generations[-1].size.to_f
  puts "mean fitness recalc #{tmp}"

  puts "*"*30
}
