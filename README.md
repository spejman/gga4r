#README for gga4r


##Introduction

General Genetic Algorithm for Ruby is a Ruby Genetic Algorithm that is very simple to use:

1) Take a class to evolve it and define fitness, recombine and mutate methods.

```ruby
class StringPopulation < Array
  def fitness
    self.select { |pos| pos == 1 }.size.to_f / self.size.to_f
  end

  def recombine(c2)
    cross_point = (rand * c2.size).to_i
    c1_a, c1_b = self.separate(cross_point)
    c2_a, c2_b = c2.separate(cross_point)
    [StringPopulation.new(c1_a + c2_b), StringPopulation.new(c2_a + c1_b)]
  end

  def mutate
    mutate_point = (rand * self.size).to_i
    self[mutate_point] = 1
  end
end
```

2) Create a GeneticAlgorithm object with the population.

```ruby
def create_population_with_fit_all_1s(s_long = 10, num = 10)
    population = []
    num.times  do
      chromosome = StringPopulation.new(Array.new(s_long).collect { (rand > 0.2) ? 0:1 })
      population << chromosome
    end
    population
end

ga = GeneticAlgorithm.new(create_population_with_fit_all_1s)
```

3) Call the evolve method as many times as you want and see the best evolution.

```ruby
100.times { |i|  ga.evolve }
p ga.best_fit[0]
```

##Install

1. Execute:
```
gem install gga4r
```

2. Add require in your code headers:
```
require "rubygems"
require "gga4r"
```

##Attention

Please note that Gga4r adds shuffle, shuffle!, each_pair and separate methods to the Array class.

##Documentation

Documentation can be generated using rdoc tool under the source code with:
```
rdoc README lib
```

##Contributors

- Ben Prew https://github.com/benprew
- Rory O'Kane
- Sergio Espeja https://github.com/spejman


##Copying

This work is developed by Sergio Espeja ( www.upf.edu/pdi/iula/sergio.espeja, sergio.espeja at gmail.com )
mainly in Institut Universitari de Lingüística Aplicada of Universitat Pompeu Fabra ( www.iula.upf.es ),
and also in bee.com.es ( bee.com.es ).

It is free software, and may be redistributed under GPL license.



