# frozen_string_literal: true

require_relative 'lib/google_logger/version'
require 'rake'

Gem::Specification.new do |spec|
  spec.name          = 'google_logger'
  spec.version       = GoogleLogger::VERSION
  spec.authors       = ['Jan Hric']
  spec.email         = ['hric95@seznam.cz']

  spec.summary       = 'Provides a simple interface to write logs to the google cloud platform.'
  spec.description   = 'Provides convenient methods to log all controller requests
                       and also provides a wrapper class which simplifies custom logging.'
  spec.homepage      = 'https://yova.ch/'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')
  spec.license = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://yova.ch/'

  # Specify which files should be added to the gem when it is released.
  spec.files         = FileList['lib/**/*.rb']

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib lib/google_logger lib/google_logger/loggers]

  # google cloud api
  spec.add_dependency 'activesupport', '>= 5.2.4.5'
  spec.add_dependency 'stackdriver', '>= 0.21.1'
end
