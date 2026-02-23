# -*- encoding: utf-8 -*-
# stub: neighbor 0.4.3 ruby lib

Gem::Specification.new do |s|
  s.name = "neighbor".freeze
  s.version = "0.4.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Andrew Kane".freeze]
  s.date = "2024-09-02"
  s.email = "andrew@ankane.org".freeze
  s.homepage = "https://github.com/ankane/neighbor".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.1".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Nearest neighbor search for Rails and Postgres".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<activerecord>.freeze, [">= 6.1"])
end
