require_relative './helper'

describe Bitget::Error do
  def error(body)
    Bitget::Error.new(code: 400, message: 'Bad Request', body: body)
  end

  let(:suspended_body){'{"code":"25102","msg":"The symbol is currently suspended. Please refer to official announcements for the specific reopening time.","requestTime":1790320628183,"data":null}'}

  describe "#error_code" do
    it "is Bitget's code from the body" do
      _(error(suspended_body).error_code).must_equal('25102')
    end

    it "is the HTTP code where the body has none" do
      _(error('').error_code).must_equal(400)
    end
  end

  describe "#documented_message" do
    it "is the message documented for the code" do
      _(error(suspended_body).documented_message).must_equal('Trading pair temporarily closed for maintenance')
    end

    it "prefers the V2 REST list over the others" do
      _(error('{"code":"43117","msg":""}').documented_message).must_equal(Bitget::ERROR_CODES[:v2_rest]['43117'])
    end

    it "is each message of a code listed twice in the one list, numbered" do
      first, second = Bitget::ERROR_CODES[:v2_rest]['40104']
      _(error('{"code":"40104","msg":""}').documented_message).must_equal("(1) #{first}; (2) #{second}")
    end

    it "is nil for a code no list documents" do
      _(error('{"code":"99999999","msg":""}').documented_message).must_be_nil
    end

    it "is nil where the body has no code" do
      _(error('').documented_message).must_be_nil
    end
  end

  describe "#market_unavailable?" do
    it "is true for each of the codes for a market which cannot be traded" do
      Bitget::Error::MARKET_UNAVAILABLE_CODES.each do |code|
        _(error(%Q{{"code":"#{code}","msg":""}}).market_unavailable?).must_equal(true)
      end
    end

    it "is true for a suspended symbol" do
      _(error(suspended_body).market_unavailable?).must_equal(true)
    end

    it "is false for any other code" do
      _(error('{"code":"43012","msg":"Insufficient balance"}').market_unavailable?).must_equal(false)
    end

    it "is false where the body has no code" do
      _(error('').market_unavailable?).must_equal(false)
    end
  end

  describe "#to_s" do
    it "gives Bitget's code and the message as returned" do
      _(error(suspended_body).to_s).must_equal('Bitget::Error: 25102 - The symbol is currently suspended. Please refer to official announcements for the specific reopening time.')
    end
  end
end
