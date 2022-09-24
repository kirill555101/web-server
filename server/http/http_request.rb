# frozen_string_literal: true

require 'uri'

class HTTPRequest
  attr_reader :method, :url, :http_version, :file, :file_type

  def initialize(string, folder)
    args_array = string.split(' ')

    @method = args_array.first.downcase.to_sym
    @url = URI.decode_www_form_component(args_array[1].split('?').first)
    @http_version = args_array.last

    @file = @url.split('/').last

    if @file.nil? || @file.split('.').length == 1
      @file = 'index.html'
      @url += @file
    end

    @file_type = @file.split('.').last
    @url.prepend(folder)
  end

  def method_valid?
    get? || head?
  end

  def get?
    method == :get
  end

  def head?
    method == :head
  end
end
