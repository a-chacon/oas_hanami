# frozen_string_literal: true

require "rack"
require "oas_core"
require "debug"

OasCore.configure_yard!

module OasHanami
  autoload :VERSION, "oas_hanami/version"
  autoload :Configuration, "oas_hanami/configuration"
  autoload :RouteExtractor, "oas_hanami/route_extractor"
  autoload :OasRouteBuilder, "oas_hanami/oas_route_builder"
  autoload :HanamiRouteFormatter, "oas_hanami/hanami_route_formatter"
  autoload :Inspector, "oas_hanami/inspector"

  module Web
    autoload :View, "oas_hanami/web/view"
  end

  class << self
    def build
      clear_cache
      OasCore.config = config

      host_routes = RouteExtractor.host_routes
      oas_source = config.source_oas_path ? read_source_oas_file : {}

      OasCore.build(host_routes, oas_source: oas_source)
    end

    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    def clear_cache
      return if Hanami.env?(:production)

      MethodSource.clear_cache
      RouteExtractor.clear_cache
    end

    def read_source_oas_file
      file_path = Hanami.app.root.join(config.source_oas_path)

      JSON.parse(File.read(file_path), symbolize_names: true)
    rescue Errno::ENOENT => e
      raise "Failed to read source OAS file at #{file_path}: #{e.message}"
    rescue JSON::ParserError => e
      raise "Failed to parse source OAS file at #{file_path}: #{e.message}"
    end
  end
end
