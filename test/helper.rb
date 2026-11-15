# webmock's http_rb adapter's require 'http' finds http.rb's lib/http.rb,
# takes HTTP::VERSION for the http gem's, and crashes trying to
# monkey-patch an HTTP::Client which isn't there.
def skip_webmocks_http_rb_adapter
  gem 'webmock'

  $LOADED_FEATURES << File.join(
    Gem.loaded_specs['webmock'].full_gem_path,
    'lib/webmock/http_lib_adapters/http_rb_adapter.rb'
  )
end

skip_webmocks_http_rb_adapter

require 'minitest/autorun'
require 'minitest/mock'
require 'minitest/spec'
require 'minitest-spec-context'
require 'vcr'
require 'webmock' # Necessary? Was working without.

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require 'bitget'

VCR.configure do |config|
  # config.cassette_library_dir = File.expand_path('../fixtures/vcr_cassettes', __FILE__)
  config.cassette_library_dir = 'test/fixtures/vcr_cassettes'

  config.hook_into :webmock

  config.filter_sensitive_data('<API_KEY>'){ENV['BITGET_API_KEY']}
  config.filter_sensitive_data('<API_SECRET>'){ENV['BITGET_API_SECRET'] }
  config.filter_sensitive_data('<API_PASSPHRASE>'){ENV['BITGET_API_PASSPHRASE']}
end

class Minitest::Test
  def before_setup
    super
    Bitget.reset_configuration!
  end
end
