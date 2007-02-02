require "yaml"

class GeneticAlgorithm
  attr_reader :generations, :p_combination, :p_mutation
  
  # Must be initialized with a Array of chromosomes
  # To be a chomosome the object must implement the next methods:
  #  - fitness
  #  - recombine
  #  - mutate
  #  
  def initialize(in_pop, prop = {})    
    @generations = [in_pop]
    @generations += prop[:extra_generations] if prop[:extra_generations]
    @p_combination = prop[:p_combination] || 0.2
    @p_mutation = prop[:p_mutation] || 0.01
#    mean_fitness
  end


# HELPER METHODS

  # Returns the number of generations computed.
  def num_generations
    @generations.size - 1
  end

  # Returns the best fitted chromosomes in given
  # generation ( last by default ).
  def best_fit(num_generation = -1)
    raise "Generation not generated still num generations = #{num_generations}" if num_generation > num_generations  
    generation = @generations[num_generation]
    max_fitness = generation.collect { |chromosome| chromosome.fitness }.max
    generation.select { |chromosome| chromosome.fitness == max_fitness }
  end
  
  def mean_fitness(num = -1)
    raise "Generation not generated still num generations = #{num_generations}" if num > num_generations
    num = self.num_generations if num == -1
    sum_fitness = 0
    @generations[num].each { |chromosome| sum_fitness += chromosome.fitness }
    sum_fitness.to_f / @generations[num].size.to_f
  end

  # Returns a GeneticAlgorithm object with the generations
  # loaded from given files and with properties prop.
  def self.populate_from_files(a_filenames, prop = {})
    a_filenames = [a_filenames] if a_filenames.class == String
    
    loaded_generations = a_filenames.collect { |filename| YAML.load(File.open(filename, "r")) }
    prop[:extra_generations] = loaded_generations[1,-1] if loaded_generations.size > 1
    return GeneticAlgorithm.new(loaded_generations[0], prop)
  end

  def save_generation(filename, num_generation = -1)
    f = File.new(filename, "w")
    f.write(self.generations[num_generation].to_yaml)
    f.close    
  end
# EVOLUTION METHODS

  # Evolves the actual generation num_steps steps (1 by default).
  def evolve(num_steps = 1)
    num_steps.times do
      @generations << evaluation(@generations[-1])
      selection!
      recombination! 
      mutation!
    end
  end
  
  # Prepares given generation for evaluation ( evaluates its fitness ).
  def evaluation(g)
    g.collect { |chromosome| chromosome.fitness; chromosome }
  end
  
  # Selects population to survive and recombine
  def selection(g)
    remainder_stochastic_sampling(g)
  end
  def selection!; @generations[-1] = selection(@generations[-1]); end

  # Recombines population  
  def recombination(g)
    new_generation = g.dup.shuffle!
    new_childs = []
    new_generation.each_pair do |chromosome1, chromosome2|
      if rand > (1 - @p_combination)
        new_childs = chromosome1.recombine(chromosome2)
      end
    end
    new_generation + new_childs    
  end

  def recombination!; @generations[-1] = recombination(@generations[-1]); end

  # Mutates population
  def mutation(g)
    new_generation = g.dup
    new_generation.each do |chromosome|
      chromosome.mutate if rand > (1 - @p_mutation)
    end
  end
  def mutation!; @generations[-1] = mutation(@generations[-1]); end
  
  # Remainder Stochastic Sampling algorithm for selection.
  def remainder_stochastic_sampling(g)
    new_generation = []
    g.each do |chromosome|
      num_rep = 0
      num_rep += (chromosome.fitness/mean_fitness).to_i
      num_rep += 1 if rand > (1 - (chromosome.fitness/mean_fitness)%1)
      new_generation = new_generation + ([chromosome] * num_rep)
    end
    new_generation
  end

end