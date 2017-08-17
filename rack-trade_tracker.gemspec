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
  spec.description   = <<~DESC
   TradeTracker.com operates using a redirect mechanism.
    This gem enables this redirection as Rack middleware so that it is
    isolated from the main (e.g. Rails) app.
  DESC
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
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
  
  spec.add_dependency 'activesupport'
end
