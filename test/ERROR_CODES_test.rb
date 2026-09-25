require_relative './helper'

describe Bitget do
  describe "ERROR_CODES" do
    it "has a table for each list, in order of precedence" do
      _(Bitget::ERROR_CODES.keys).must_equal(%i{v2_rest v2_websocket uta_rest})
    end

    it "is frozen, as is each table" do
      _(Bitget::ERROR_CODES.frozen?).must_equal(true)
      Bitget::ERROR_CODES.each_value{|error_codes| _(error_codes.frozen?).must_equal(true)}
    end

    it "keys each table by codes as strings of digits, leading zeros kept" do
      Bitget::ERROR_CODES.each_value do |error_codes|
        error_codes.each_key{|code| _(code).must_match(/\A\d+\z/)}
      end
      _(Bitget::ERROR_CODES[:v2_rest]).must_include('00001')
    end

    it "gives each code a message, or an array of them" do
      Bitget::ERROR_CODES.each_value do |error_codes|
        error_codes.each_value do |message|
          Array(message).each do |m|
            _(m).must_be_instance_of(String)
            _(m).wont_be_empty
          end
        end
      end
    end

    it "keeps both meanings of a code listed twice in the one list, as an array" do
      _(Bitget::ERROR_CODES[:v2_rest]['40104'].size).must_equal(2)
      _(Bitget::ERROR_CODES[:v2_rest]['40104'].first).must_match(/located in a country or region/)
      _(Bitget::ERROR_CODES[:v2_rest]['40104'].last).must_match(/Unable to withdraw to this account/)
    end

    it "keeps a message Bitget itself separates with slashes as the one string" do
      _(Bitget::ERROR_CODES[:uta_rest]['60053']).must_match(%r{\Aparam error / Order status is not unpaid})
    end

    it "has no message numbered as Bitget::Error#documented_message numbers them" do
      Bitget::ERROR_CODES.each_value do |error_codes|
        error_codes.each_value{|message| Array(message).each{|m| _(m).wont_match(/\(\d+\)/)}}
      end
    end

    it "decodes HTML entities" do
      _(Bitget::ERROR_CODES[:v2_rest]['22006']).must_equal('limit price > risk price')
    end

    it "omits Bitget's placeholder for an undescribed code" do
      Bitget::ERROR_CODES.each_value do |error_codes|
        _(error_codes.values).wont_include('未找到描述')
      end
    end
  end
end
