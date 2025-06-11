# frozen_string_literal: true

require "hanami/router/inspector"

module OasHanami
  class Inspector < Hanami::Router::Inspector
    def initialize(routes: [], formatter: HanamiRouteFormatter.new)
      super(routes:, formatter:)
    end
  end
end
