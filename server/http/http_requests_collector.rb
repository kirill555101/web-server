# frozen_string_literal: true

require 'singleton'

class HTTPRequestsCollector
  include Singleton

  def initialize
    @count = 0
  end

  def inc
    @count += 1
  end

  def body
    result =
      "# HELP requests_count Number of requests on server\n" \
      "# TYPE requests_count counter\n" \
      "requests_count #{@count}"
    @count = 0
    result
  end
end
