# bitget.gemspec

require_relative './lib/Bitget/VERSION'

Gem::Specification.new do |spec|
  spec.name = 'bitget'
  spec.version = Bitget::VERSION

  spec.summary = "Access the Bitget API with Ruby."
  spec.description = "Access the Bitget API with Ruby."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'http://github.com/thoran/bitget'
  spec.license = 'Ruby'

  spec.required_ruby_version = '>= 2.7'
  spec.require_paths = ['lib']

  spec.add_dependency('http.rb')
  spec.files = [
    'bitget.gemspec',
    Dir['lib/**/*.rb'],
    Dir['test/**/*.rb'],
    'Gemfile',
    'LICENSE',
    'README.md',
  ].flatten
end
