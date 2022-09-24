# frozen_string_literal: true

class ConfigParser
  def call
    file = open(PATH_TO_CONFIG)
    rows = file.read.split("\n")

    workers_count = rows
      .select { |row| row.include?('cpu_limit') }.first
      .split(' ').last.to_i
    static_folder = rows
      .select { |row| row.include?('document_root') }.first
      .split(' ').last

    [workers_count, static_folder]
  end

  private

  PATH_TO_CONFIG = '/etc/httpd.conf'.freeze
end
