# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'homie/version'

Gem::Specification.new do |spec|
  spec.name          = "homie"
  spec.version       = Homie::VERSION
  spec.authors       = ["Viacheslav Shvetsov"]
  spec.email         = ["shvetsov1988@gmail.com"]

  spec.summary       = %q{Implementation of Observer pattern with using objects or code blocks.}
  spec.description   = %q{Implementation of Observer pattern.}
  spec.license       = "MIT"
  spec.homepage       = "https://github.com/donasktello/homie"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
