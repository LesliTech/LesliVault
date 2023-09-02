=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

require_relative "lib/lesli_vault/version"

Gem::Specification.new do |spec|
  spec.name        = "lesli_vault"
  spec.version     = LesliVault::VERSION
  spec.authors     = ["The Lesli Development Team"]
  spec.email       = ["hello@lesli.tech"]
  spec.homepage    = "https://www.lesli.dev/"
  spec.summary     = "Security module for Lesli"
  spec.description = "Lesli provides all the necessary tools to build your SaaS, empowering you and your team to focus on business and what makes your software special. "
  # spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/LesliTech/Lesli"
  spec.metadata["changelog_uri"] = "https://github.com/LesliTech/Lesli"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]
  end

  spec.required_ruby_version = ">= 2.7.2"

  spec.add_dependency "rails", "~> 7"
end
