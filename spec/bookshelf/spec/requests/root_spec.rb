# frozen_string_literal: true

RSpec.describe "Root", type: :request do
  it "is successful" do
    get "/"

    expect(last_response.body).to eq("Welcome to Bookshelf")
    expect(last_response).to be_successful
  end
end
