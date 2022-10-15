# frozen_string_literal: true

require_relative 'http_requests_collector'

class HTTPResponse
  def initialize(request:, status:)
    @request = request
    @status = status
  end

  def call
    puts "Connection [#{request.method.upcase}] [URL #{request.url}] [STATUS #{STATUSES[status]}]"

    result = request.http_version + ' ' + status_code + "\r\n" + headers + "\r\n\r\n"
    result += body if request.get? && status == :ok
    result
  end

  private

  STATUSES = {
    ok: 200,
    forbidden: 403,
    not_found: 404,
    not_allowed: 405,
  }.freeze

  attr_reader :request, :status

  def status_code
    STATUSES[status].to_s + ' ' + status.to_s.split('_').map(&:capitalize).join(' ')
  end

  def headers
    @headers = [
      'Server: web-server',
      "Date: #{Time.now.utc}",
      'Connection: close'
    ]

    @headers.push(content_type).push(content_length) if status == :ok && !body.empty?
    @headers.join("\r\n")
  end

  def content_type
    return 'Content-Type: text/plain' if request.metrics_url?

    case request.file_type
    when 'html'
      'Content-Type: text/html'
    when 'css'
      'Content-Type: text/css'
    when 'js'
      'Content-Type: text/javascript'
    when 'jpg'
      'Content-Type: image/jpeg'
    when 'jpeg'
      'Content-Type: image/jpeg'
    when 'png'
      'Content-Type: image/png'
    when 'gif'
      'Content-Type: image/gif'
    when 'swf'
      'Content-Type: application/x-shockwave-flash'
    else
      'Content-Type: text/plain'
    end
  end

  def content_length
    length =
      if request.metrics_url?
        body.length
      else
        File.size(request.url)
      end
    "Content-Length: #{length}"
  end

  def body
    @body ||=
      if request.metrics_url?
        HTTPRequestsCollector.instance.body
      else
        open(request.url).read
      end
  end
end
