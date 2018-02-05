lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_model/logger_attributes/version"

Gem::Specification.new do |spec|
  spec.name = 'activemodel-logger_attributes'
  spec.version = ActiveModel::LoggerAttributes::VERSION
  spec.authors = ['Chris Bielinski']
  spec.email = ['chris@shadow.io']
  spec.licenses = ['MIT']
  spec.summary = 'Write Ruby logger messages to an ActiveModel attribute'
  spec.description = 'Provides a Logger::LogDevice that can save Ruby Logger messages to an array in your model'
  spec.homepage = "https://github.com/chrisb/activemodel-logger_attributes"
  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'activemodel', '> 4', '< 6'
  spec.add_development_dependency 'awesome_print', '~> 1'
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
