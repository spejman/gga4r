require 'logger'

class GeneticAlgorithm
  VERSION = '0.9.3'

  # Must be initialized with a Array of chromosomes
  # To be a chomosome the object must implement the next methods:
  #  - fitness
  #  - recombine
  #  - mutate
  #  - distance (only for multi-modal optimization)
  #  Accepts the next properties:
  #   - max_population: maximum number of individuals that are allowed to form a generation.
  #   - logger: logger to write messages if given.
  #   - multi_recombination: set to true if the result of a chromosome's #recombination method
  #     returns an array. Default to false
  #   - multi_modal: set to true to use a multi-modal algorithm using deterministic crowding and a distance-derated fitness.
  #   - share_radius: in multi-modal optimization, determines the niche radius for derated fitness calculation. 
  def initialize(in_pop, prop = {})
    @max_population =  prop[:max_population]
    @logger = prop[:logger] || Logger.new('/dev/null')
    @population = in_pop
    @multi_recombination = prop[:multi_recombination] || false
    @generations = []
    @multi_modal = prop[:multi_modal] || false
    @share_radius = prop[:share_radius] or 3
  end

  # Returns an array with the best fitted individuals for last generation
  def best_fit
    @population.max_by(&:fitness)
  end

  # Returns an array with the best fitted n individuals from the population (might include local optima)
  def best_fitted(n)
    @population.uniq.sort_by{|c| -c.fitness}.first(n)
  end

   # Returns an array with the best fitted n individuals from the population (might include local optima)
   # Uses a distance-derated fitness metric
  def best_fitted_derated(n)
    @population.uniq.sort_by{|c| -(derated_fitness(c,@population))}.first(n)
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
  def evolve(num_steps = 1)
    num_steps.times do |t|
      @population = selection(@population)
      new_gen = @population.map { |chromosome| chromosome.dup }
      if !@multi_modal
        @population += recombination(new_gen) + mutation(new_gen)
      else
        @population = deterministic_crowding(@population)
        @population = mutation(@population)
      end
    end
  end

  private

  # Selects population to survive and recombine
  def selection(g)
      @max_population && g.length > @max_population ? g.sort_by{|c| -c.fitness}.first(@max_population) : g
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
    new_children.flatten!(1) if @multi_recombination
    new_generation + new_children
  end

  def deterministic_crowding(g)
    groups = g.shuffle
    group1 = groups.first(g.length/2)
    group2 = groups[g.length/2..-1]

    new_gen = []

    group1.each_with_index do |p1,i|
      p2 = group2[i]

      if p2

        c1, c2 = p1.recombine(p2)

        if p1.distance(c1) + p2.distance(c2) <= p1.distance(c2) + p2.distance(c1)
          new_gen << [p1,c1].max_by{|c| derated_fitness(c,g)}
          new_gen << [p2,c2].max_by{|c| derated_fitness(c,g)}
        else 
          new_gen << [p1,c2].max_by{|c| derated_fitness(c,g)}
          new_gen << [p2,c1].max_by{|c| derated_fitness(c,g)}
        end
      else
        new_gen << p1
      end
    end
    new_gen
  end

  def derated_fitness(c,g)
    share_count = g.map{|c2| [(1-c.distance(c2)/@share_radius),0].max }.sum
    share_count = Float::EPSILON if share_count==0
    c.fitness/share_count
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
