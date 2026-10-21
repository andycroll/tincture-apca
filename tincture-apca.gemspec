# frozen_string_literal: true

require_relative 'lib/tincture/apca/version'

Gem::Specification.new do |spec|
  spec.name = 'tincture-apca'
  spec.version = Tincture::Apca::VERSION
  spec.authors = ['Andy Croll']
  spec.email = ['andy@goodscary.com']

  spec.summary = 'APCA contrast for Tincture colours, for WCAG web content only'
  spec.description = 'Adds APCA lightness contrast (Lc) to Tincture::Color, ported from apca-w3. ' \
                     'Its licence restricts use to web content in support of WCAG.'
  spec.homepage = 'https://github.com/andycroll/tincture-apca'
  spec.license = 'LicenseRef-apca-w3'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    Dir['{lib}/**/*', 'CHANGELOG.md', 'LICENSE.md', 'README.md']
  end

  spec.require_paths = ['lib']

  spec.add_dependency 'tincture', '~> 0.1'
end
