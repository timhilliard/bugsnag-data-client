Gem::Specification.new do |s|
  s.name = 'bugsnag_data'
  s.version = '1.0.0'
  s.license = 'Apache-2.0'
  s.summary = 'Bugsnag Data API Client library'
  s.description = 'Use the Bugsnag Data REST API'
  s.authors = ['Tim Hilliard']
  s.email = 'timhilliard@gmail.com'
  s.homepage = 'http://github.com/timhilliard/bugsnag-data-client'
  s.date = '2014-12-15'

  s.require_paths = ['lib']
  s.extra_rdoc_files = [
    'LICENSE',
    'README.md',
    'example.rb'
  ]
  s.files = [
    'Gemfile',
    'lib/bugsnag_data.rb'
  ]

  s.add_runtime_dependency('httparty', ['~> 0.13.3'])

  s.add_development_dependency('rake', ['~> 10.4.2'])
  s.add_development_dependency('webmock', ['~> 1.20.4'])
  s.add_development_dependency('rspec', ['~> 3.1.0'])
  s.add_development_dependency('yard', ['~> 0.8.7.6'])
  s.add_development_dependency('redcarpet', ['~> 3.2.2'])
end
