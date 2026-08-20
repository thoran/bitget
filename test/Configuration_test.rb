require_relative './helper'

describe Bitget::Configuration do
  describe "#initialize" do
    it "sets default values" do
      config = Bitget::Configuration.new
      _(config.debug).must_equal(false)
      _(config.api_key).must_be_nil
      _(config.api_secret).must_be_nil
      _(config.api_passphrase).must_be_nil
      _(config.logger).must_be_nil
    end

    it "declares a setting for everything a client reads" do
      _(Bitget::Configuration.new.public_methods(false).grep(/[^=]\z/).sort) \
        .must_equal(%i{api_key api_passphrase api_secret debug logger})
    end
  end

  # The credentials are named arguments and fall back upon nil, having no
  # meaningful nil of their own.  The options are given under options: and fall
  # back upon the key being absent, nil being a value a caller may mean.
  describe "the credentials, which are named arguments" do
    before do
      Bitget.configure do |config|
        config.api_key = 'configured_key'
        config.api_secret = 'configured_secret'
        config.api_passphrase = 'configured_passphrase'
      end
    end

    it "supplies every one, so that a client needs no arguments at all" do
      client = Bitget::Client.new
      _(client.api_key).must_equal('configured_key')
      _(client.api_secret).must_equal('configured_secret')
      _(client.api_passphrase).must_equal('configured_passphrase')
    end

    it "yields to each one given, and only to that one" do
      _(Bitget::Client.new(api_key: 'given').api_key).must_equal('given')
      _(Bitget::Client.new(api_key: 'given').api_secret).must_equal('configured_secret')
      _(Bitget::Client.new(api_secret: 'given').api_secret).must_equal('given')
      _(Bitget::Client.new(api_secret: 'given').api_key).must_equal('configured_key')
      _(Bitget::Client.new(api_passphrase: 'given').api_passphrase).must_equal('given')
      _(Bitget::Client.new(api_passphrase: 'given').api_key).must_equal('configured_key')
    end

    it "is unreachable where nothing is configured and nothing is given" do
      Bitget.reset_configuration!
      client = Bitget::Client.new
      _(client.api_key).must_be_nil
      _(client.api_secret).must_be_nil
      _(client.api_passphrase).must_be_nil
    end
  end

  describe "the options, which are given under options:" do
    let(:logger){Logger.new(StringIO.new)}

    before do
      Bitget.configure do |config|
        config.debug = true
        config.logger = logger
      end
    end

    it "supplies every one" do
      client = Bitget::Client.new
      _(client.debug).must_equal(true)
      _(client.logger).must_equal(logger)
    end

    it "yields to each one given, and only to that one" do
      other = Logger.new(StringIO.new)
      _(Bitget::Client.new(options: {debug: false}).debug).must_equal(false)
      _(Bitget::Client.new(options: {debug: false}).logger).must_equal(logger)
      _(Bitget::Client.new(options: {logger: other}).logger).must_equal(other)
      _(Bitget::Client.new(options: {logger: other}).debug).must_equal(true)
    end

    it "takes nil as a value rather than as an absence" do
      client = Bitget::Client.new(options: {logger: nil})
      _(client.logger).must_be_nil
      _(client.send(:use_logging?)).must_equal(false)
    end
  end
end
