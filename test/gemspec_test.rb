require_relative './helper'
require_relative '../lib/Bitget/VERSION'

describe 'bitget.rb.gemspec' do
  let(:spec){Gem::Specification.load(File.expand_path('../bitget.rb.gemspec', __dir__))}

  it "is a valid specification" do
    _(spec.validate).must_equal(true)
  end

  it "does not pin a date" do
    _(spec.date).must_equal(Gem::Specification.new.date)
  end

  it "takes its version from Bitget::VERSION" do
    _(spec.version.to_s).must_equal(Bitget::VERSION)
  end

  it "declares its runtime dependencies" do
    _(spec.runtime_dependencies.map(&:name).sort).must_equal(%w{http.rb})
  end
end
