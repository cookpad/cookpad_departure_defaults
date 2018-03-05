
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cookpad_departure_defaults/version"

Gem::Specification.new do |spec|
  spec.name          = "cookpad_departure_defaults"
  spec.version       = CookpadDepartureDefaults::VERSION
  spec.authors       = ["Kirk Haines"]
  spec.email         = ["kirk-haines@cookpad.com"]

  spec.summary       = %q{Cookpad's general defaults for pt-online-schema-change, as ran through the Departure gem.}
  spec.description   = %q{The gem encapsulates the baseline default tuning parameters to use for all tasks that are executed with pt-online-schema-change, driven by the Departure gem.}
  spec.homepage      = "https://github.com/cookpad/cookpad_departure_defaults"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "departure", "~> 6.1"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
