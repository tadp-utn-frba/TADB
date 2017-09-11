# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tadb/version'

Gem::Specification.new do |spec|
  spec.name          = 'tadb'
  spec.version       = TADB::VERSION
  spec.authors       = ['UTN FRBA - TADP']
  spec.email         = ['erwincdl@gmail.com']

  spec.summary       = 'File based storage'
  spec.description   = 'Toy file based object storage for academic purposes'
  spec.homepage      = 'http://tadp-utn-frba.github.io/'
  spec.license       = 'MIT'


  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.files = Dir['lib/**/*.rb']

  spec.add_development_dependency 'rspec-collection_matchers', '~> 1.1'
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
