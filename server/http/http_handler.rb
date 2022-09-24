# frozen_string_literal: true

require_relative 'http_request'
require_relative 'http_response'

class HTTPHandler
  def initialize(string, folder)
    @string = string
    @folder = folder
  end

  def call
    return unless string_valid?

    request = HTTPRequest.new(string, folder)
    return HTTPResponse.new(request: request, status: :not_allowed).call unless request.method_valid?

    unless File.exist?(request.url)
      status =
        if request.file == 'index.html'
          :forbidden
        else
          :not_found
        end
      return HTTPResponse.new(request: request, status: status).call
    end

    HTTPResponse.new(request: request, status: :ok).call
  end

  private

  attr_reader :string, :folder

  def string_valid?
    !string.nil? && string.split(' ').length == 3 && string.include?("\r\n")
  end
end
