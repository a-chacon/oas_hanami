# frozen_string_literal: true

require "oas_hanami"

module Bookshelf
  class Routes < Hanami::Routes
    root to: "home.index"
    get "/books", to: "books.index"
    get "/books/:id", to: "books.show"
    post "/books", to: "books.create"

    mount OasHanami::Web::View, at: "/docs"
  end
end
