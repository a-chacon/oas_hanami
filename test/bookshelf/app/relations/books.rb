# frozen_string_literal: true

module Bookshelf
  module Relations
    class Books < Bookshelf::DB::Relation
      schema :books, infer: true

      use :pagination
      per_page 5
    end
  end
end
