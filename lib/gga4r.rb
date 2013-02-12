require 'logger'

VERSION = '0.9.3'

class GeneticAlgorithm

  # Must be initialized with a Array of chromosomes
  # To be a chomosome the object must implement the next methods:
  #  - fitness
  #  - recombine
  #  - mutate
  #  Accepts the next properties:
  #   - max_population: maximum number of individuals that are allowed to form a generation.
  #   - logger: logger to write messages if given.
  def initialize(in_pop, prop = {})
    @max_population =  prop[:max_population]
    @logger = prop[:logger] || Logger.new('/dev/null')
    @population = in_pop
    @generations = []
  end

  # Returns an array with the best fitted individuals for given
  # generation number ( by default from last generation ).
  def best_fit
    @population.max_by(&:fitness)
  end

  # Returns a GeneticAlgorithm object with the generations
  # loaded from given files and with properties prop.
  # Files must contain the chromosomes in YAML format.
  def self.populate_from_file(filename, prop = {})
    GeneticAlgorithm.new(YAML.load(File.open(filename, 'r')), prop)
  end

  # Saves into filename and in yaml format the generation that matchs with given
  # generation number ( by default from last generation ).
  def save_population(filename)
    f = File.new(filename, "w")
    f.write(@population.to_yaml)
    f.close
  end

# EVOLUTION METHODS

  # Evolves the actual generation num_steps steps (1 by default).
  def evolve
    @population = selection(@population)
    new_gen = @population.map { |chromosome| chromosome.dup }
    @population += recombination(new_gen) + mutation(new_gen)
  end

  private

  # Selects population to survive and recombine
  def selection(g)
    @max_population && g.length > @max_population ? g.sort {|a, b| b.fitness <=> a.fitness }[0..(@max_population-1)] : g
  end

  # Recombines population
  def recombination(g)
    @logger.debug "Recombination " + g.size.to_s + " chromosomes." if @logger
    new_generation = g.dup.shuffle!
    @logger.debug "Shuffled!" if @logger
    new_children = []
    new_generation.each_slice(2) do |chromosome1, chromosome2|
      next if chromosome2.nil?
      @logger.debug "Recombining" if @logger
      new_children << chromosome1.recombine(chromosome2)
    end
    new_generation + new_children
  end

  # Mutates population
  def mutation(g)
    @logger.debug "Mutation " + g.size.to_s + " chromosomes." if @logger
    new_generation = g.dup
    new_generation.each do |chromosome|
      @logger.debug "Mutate" if @logger
      chromosome.mutate
    end
    new_generation
  end
end
