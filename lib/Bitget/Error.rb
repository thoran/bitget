# Bitget/Error.rb
# Bitget::Error

require 'json'

module Bitget
  class Error < RuntimeError
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
