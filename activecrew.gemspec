# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_crew/version'

Gem::Specification.new do |spec|
  spec.name          = 'activecrew'
  spec.version       = ActiveCrew::VERSION
  spec.authors       = ['Max Kazarin']
  spec.email         = ['maxkazargm@gmail.com']

  spec.summary       = %q{Steroid command pattern.}
  spec.description   = %q{Steroid command pattern.}
  spec.homepage      = 'https://github.com/maxkazar/activecrew'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.3'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.11'
  spec.add_development_dependency 'actionpack', '~> 7.0'

  spec.add_dependency 'activesupport', '~> 7.0'
end
