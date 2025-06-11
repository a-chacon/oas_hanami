# frozen_string_literal: true

require_relative "lib/oas_hanami/version"

Gem::Specification.new do |spec|
  spec.name = "oas_hanami"
  spec.version = OasHanami::VERSION
  spec.authors = ["achacon"]
  spec.email = ["andres.ch@protonmail.com"]

  spec.summary = "Generates OpenAPI Specification (OAS) documents by analyzing and extracting routes from Hanami applications."
  spec.description =
    "OasHanami simplifies API documentation by automatically generating OpenAPI Specification (OAS 3.1) documents from your Hanami application routes. It eliminates the need for manual documentation, ensuring accuracy and consistency."
  spec.homepage = "https://github.com/a-chacon/oas_hanami"
  spec.license = "GPL-3.0-only"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/a-chacon/oas_hanami"
  spec.metadata["changelog_uri"] = "https://github.com/a-chacon/oas_hanami/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "oas_core", "~> 0.5.3"
end
