# frozen_string_literal: true

module Bookshelf
  module Actions
    module Books
      class Index < Bookshelf::Action
        include Deps["repos.book_repo"]

        params do
          optional(:page).value(:integer, gt?: 0)
          optional(:per_page).value(:integer, gt?: 0, lteq?: 100)
        end

        def handle(request, response)
          halt 422 unless request.params.valid?

          books = book_repo.all_by_title(
            page: request.params[:page] || 1,
            per_page: request.params[:per_page] || 5
          )

          response.format = :json
          response.body = books.map(&:to_h).to_json
        end
      end
    end
  end
end
