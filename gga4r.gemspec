# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'gga4r'
  s.version = "0.9.3"
  s.platform = Gem::Platform::RUBY
  s.authors = [ 'Sergio Espeja', "Rory O'Kane", 'Ben Prew' ]
  s.email = 'sergio.espeja@gmail.com'
  s.homepage = 'http://gga4r.rubyforge.org/'
  s.summary = "A Ruby Genetic Algorithm"
  s.description = "gga4r is simple to use: 1, take a class to evolve it and define fitness, recombine and mutate methods. 2, create a GeneticAlgorithm object with the population. 3, call evolve method as many times as you want.description of gem"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "gga4r"

  s.files = Dir.glob("lib/**/*")
  s.require_paths = ["lib/"]

  s.add_dependency 'psych'
  s.add_development_dependency "hoe"
end
