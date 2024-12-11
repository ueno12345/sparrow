# frozen_string_literal: true

require_relative "lib/swallow/version"

Gem::Specification.new do |spec|
  spec.name          = "swallow"
  spec.version       = Swallow::VERSION
  spec.authors       = ["ueno12345"]
  spec.email         = ["ueno2022@s.okayama-u.ac.jp"]

  spec.summary       = "Nurse scheduling Solver with AUK"
  spec.description   = "Nurse scheduling Solver with AUK"
  spec.homepage      = "https://github.com/ueno12345/swallow"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ueno12345/swallow"
  spec.metadata["changelog_uri"] = "https://github.com/ueno12345/swallow/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.add_dependency "activesupport"
  spec.add_dependency "nokogiri"
  spec.add_dependency 'ravensat', git: 'https://github.com/username/dependency-gem.git', branch: 'master'
  spec.add_dependency "rufo"
  spec.add_dependency "sycamore"
end
