# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'voltaire/version'

Gem::Specification.new do |spec|
  spec.name          = "voltaire"
  spec.version       = Voltaire::VERSION
  spec.authors       = ["Dan Donche"]
  spec.email         = ["dan@totaldanarchy.com"]

  spec.summary       = %q{A simple reputation system for rails.}
  spec.description   = %q{Provides an easy way to add user reputation into a rails app.}
  spec.homepage      = "https://github.com/ddonche/voltaire"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
end
