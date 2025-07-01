# frozen_string_literal: true

Hanami.app.register_provider(:nil) do
  prepare do
    require "oas_hanami"
  end

  start do
    OasHanami.configure do |config|
      config.info.title = "Amazing Hanami API"
      config.source_oas_path = "lib/oas.json"
    end
  end
end
