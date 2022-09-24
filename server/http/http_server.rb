# frozen_string_literal: true

require 'socket'

require_relative 'http_handler'

class HTTPServer
  def initialize(port, workers_count, folder)
    @server = TCPServer.new(port)
    @workers_count = workers_count
    @folder = folder
    @workers_array = []
  end

  def call
    init_workers
    loop do; end
  end

  private

  attr_reader :server, :workers_count, :folder, :workers_array

  def init_workers
    master_pid = Process.pid
    busy_workers_count = 0

    loop do
      break if busy_workers_count == workers_count
      busy_workers_count += 1
      next unless Process.pid == master_pid

      fork_process
    rescue SystemExit, Interrupt
      raise
    rescue Exception => e
      workers_array.each { |pid| Process.kill('TERM', pid) }
      shutdown
    end
  end

  def fork_process
    pid = fork do
      Signal.trap('TERM') { shutdown }
      workers_array.push(pid)
      puts "Forked #{Process.pid}"

      loop do
        session = server.accept
        break if session.nil?

        result = HTTPHandler.new(session.gets, folder).call
        session.print(result) unless result.nil?

        session.close
      end
    end
  end
end
