# frozen_string_literal: true

require_relative 'config_parser'
require_relative 'http/http_server'

PORT = (ARGV.first || 80).to_i

workers_count, folder = ConfigParser.new.call
HTTPServer.new(PORT, workers_count, folder).call
