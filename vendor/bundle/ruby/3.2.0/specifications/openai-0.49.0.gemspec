# -*- encoding: utf-8 -*-
# stub: openai 0.49.0 ruby lib

Gem::Specification.new do |s|
  s.name = "openai".freeze
  s.version = "0.49.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "https://gemdocs.org/gems/openai", "rubygems_mfa_required" => "false", "source_code_uri" => "https://github.com/openai/openai-ruby" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["OpenAI".freeze]
  s.date = "2026-02-14"
  s.email = "support@openai.com".freeze
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze]
  s.homepage = "https://gemdocs.org/gems/openai".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.2.0".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Ruby library to access the OpenAI API".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<base64>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<cgi>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<connection_pool>.freeze, [">= 0"])
end
