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
