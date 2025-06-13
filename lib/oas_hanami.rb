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
      OasCore.config = config

      RouteExtractor.host_routes
      # oas = OasCore::Builders::SpecificationBuilder.new.with_oas_routes(host_routes).build
      #
      # oas.to_spec
    end

    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end
  end
end
