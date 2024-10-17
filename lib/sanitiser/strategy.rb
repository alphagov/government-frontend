module Sanitiser
  class Strategy
    class SanitisingError < StandardError; end

    class << self
      def call(input, sanitize_null_bytes: false)
        input
          .force_encoding(Encoding::ASCII_8BIT)
          .encode!(Encoding::UTF_8)
        if sanitize_null_bytes && Rack::UTF8Sanitizer::NULL_BYTE_REGEX.match?(input)
          raise NullByteInString
        end
      rescue StandardError
        raise SanitisingError, "Non-UTF-8 (or null) character in the query or in the cookie"
      end
    end
  end
end
