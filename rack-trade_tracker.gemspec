# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rack/trade_tracker/version"

Gem::Specification.new do |spec|
  spec.name          = "rack-trade_tracker"
  spec.version       = Rack::TradeTracker::VERSION
  spec.authors       = ["Ben Forrest"]
  spec.email         = ["ben@clickmechanic.com"]

  spec.summary       = "Provides TradeTracker redirect endpoint as Rack middleware" 
  spec.description   = "The Rack::TradeTracker gem is for use with the Trade Tracker affiliate network.  The gem provides a Rack middleware component to handle Trade Tracker's redirect mechanism."
  spec.homepage      = "https://github.com/ClickMechanic/rack-trade_tracker"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter"
  
  spec.add_dependency 'activesupport'
  spec.add_dependency "rack"
end
