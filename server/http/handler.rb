# frozen_string_literal: true

require_relative 'request'
require_relative 'response'

module HTTP
  class Handler
    def initialize(string, folder)
      @string = string
      @folder = folder
    end

    def call
      return unless string_valid?

      request = HTTP::Request.new(string, folder)
      return HTTP::Response.new(request: request, status: :not_allowed).call unless request.method_valid?

      return HTTP::Response.new(request: request, status: :ok).call if request.metrics_url?

      unless File.exist?(request.url)
        status =
          if request.file == 'index.html'
            :forbidden
          else
            :not_found
          end
        return HTTP::Response.new(request: request, status: status).call
      end

      HTTP::Response.new(request: request, status: :ok).call
    end

    private

    attr_reader :string, :folder

    def string_valid?
      !string.nil? && string.split(' ').length == 3 && string.include?("\r\n")
    end
  end
end
