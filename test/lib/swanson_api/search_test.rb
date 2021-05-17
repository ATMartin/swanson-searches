require "test_helper"

class SwansonApi::SearchTest < ActiveSupport::TestCase
  setup do
    @service = SwansonApi::Search.new
  end

  test "it returns an empty array for no search results" do
    stub_request(:get, SwansonApi::Search.new.root_url + "/search/Bacon").to_return({body: "[]"})

    response = @service.search(query: "Bacon")

    assert response.is_a? Array
    assert_equal response.length, 0
  end

  test "it returns valid search results" do
    stub_request(:get, SwansonApi::Search.new.root_url + "/search/Bacon")
      .to_return({body: "[\"Bacon First\",\"Bacon Second\"]"})

    response = @service.search(query: "Bacon")

    assert response.is_a? Array
    assert_equal response.length, 2
    assert_includes response, "Bacon First"
    assert_includes response, "Bacon Second"
  end

  test "it forwards errors from the source API" do
    stub_request(:get, SwansonApi::Search.new.root_url + "/search/Bacon")
      .to_return({status: 400, body: "Something went wrong"})

    error = assert_raises SwansonApi::Error do
      @service.search(query: "Bacon")
    end

    assert_equal error.status, 400
    assert_equal error.message, "Something went wrong"
  end

  test "it raises a clear error when the source API is unavailable" do
    stub_request(:get, SwansonApi::Search.new.root_url + "/search/Bacon")
      .to_raise(Faraday::ConnectionFailed)

    error = assert_raises SwansonApi::Error do
      @service.search(query: "Bacon")
    end

    assert_equal error.status, 500
    assert_equal error.message, "We were unable to connect to the Swanson Quotes API. Please try again later."
  end
end
