# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

# Use a sibling checkout of tincture when there is one, as in local development.
if File.directory?(File.expand_path('../tincture', __dir__))
  gem 'tincture', path: '../tincture'
else
  gem 'tincture', github: 'andycroll/tincture'
end

group :development, :test do
  gem 'minitest'
  gem 'rake'
  gem 'rbs'
  gem 'rdoc', '>= 8.1'
  gem 'rubocop'
end
