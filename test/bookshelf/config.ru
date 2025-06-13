# frozen_string_literal: true

require "hanami/boot"
require "oas_hanami"

Hanami.app.router(inspector: OasHanami::Inspector.new)

run Hanami.app
