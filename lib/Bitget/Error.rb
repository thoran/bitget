# Bitget/Error.rb
# Bitget::Error

require 'json'

require_relative './ERROR_CODES'

module Bitget
  class Error < RuntimeError
    # Codes for a market which cannot be traded at present, whether closed for
    # maintenance, not yet open, or delisted.  Chosen by hand rather than read
    # from ERROR_CODES, since what a code is documented to mean and what it is
    # returned for are not certain to agree.
    MARKET_UNAVAILABLE_CODES = %w{25101 25102 40309 45043 50027}

    attr_reader\
      :code,
      :message,
      :body

    # Bitget answers most errors with a JSON body carrying its own code and
    # message, which are more use than the HTTP ones.  Not all of them: a 418
    # arrives with an empty body and there is nothing to parse.  Where the body
    # says nothing the HTTP code and message answer instead, so that an error
    # renders as something rather than as a pair of blanks.
    def error_code
      @parsed_body['code'] || @code
    end

    def error_message
      @parsed_body['msg'] || @parsed_body['message'] || @message
    end

    # The message documented for the code by the first of the lists in
    # ERROR_CODES to document it, or nil for a code no list documents.  A code
    # listed more than once in the one list answers with each of its messages,
    # numbered and separated: "(1) ...; (2) ...".  The numbers delimit them, no
    # documented message containing such a number, which bin/generate_error_codes
    # checks, so a semicolon within a message is no matter.
    def documented_message
      message = ERROR_CODES.values.filter_map{|error_codes| error_codes[error_code.to_s]}.first
      return message unless message.is_a?(Array)
      message.each_with_index.map{|m, i| "(#{i + 1}) #{m}"}.join('; ')
    end

    def market_unavailable?
      MARKET_UNAVAILABLE_CODES.include?(error_code.to_s)
    end

    def to_s
      "Bitget::Error: #{error_code} - #{error_message}"
    end

    private

    def initialize(code:, message:, body:)
      @code = code
      @message = message
      @body = body
      @parsed_body = parsed(body)
    end

    # An error is raised in answer to something already having gone wrong, so it
    # must construct from whatever arrived.  Raising a JSON::ParserError from
    # here loses the error being reported and replaces it with one about parsing.
    def parsed(body)
      JSON.parse(body)
    rescue JSON::ParserError
      {}
    end
  end
end
