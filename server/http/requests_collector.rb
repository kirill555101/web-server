# frozen_string_literal: true

require 'singleton'

module HTTP
  class RequestsCollector
    include Singleton

    def initialize
      @count = 0
    end

    def inc
      @count += 1
    end

    def body
      "# HELP requests_count Number of requests on server\n" \
      "# TYPE requests_count counter\n" \
      "requests_count #{@count}"
    end
  end
end
