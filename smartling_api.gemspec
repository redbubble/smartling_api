# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smartling_api/version'

Gem::Specification.new do |spec|
  spec.name          = "smartling_api"
  spec.version       = SmartlingApi::VERSION
  spec.authors       = ["Redbubble"]
  spec.email         = ["developers@redbubble.com"]

  spec.summary       = %q{Wrapper for the Smartling API.}
  spec.homepage      = "https://www.redbubble.com/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake",    "~> 10.0"
  spec.add_development_dependency "rspec",   "~> 3.4"
  spec.add_development_dependency "webmock", "~> 2.1"
  spec.add_development_dependency "pry",     "~> 0.10"
  spec.add_runtime_dependency "faraday",     "~> 0.9"
  spec.add_runtime_dependency "faraday_middleware",     "~> 0.9"
end
