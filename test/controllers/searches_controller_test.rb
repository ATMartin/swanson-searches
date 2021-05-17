require "test_helper"

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    Search.create(query: "Bacon", quotes: ["Bacon First", "Bacon Second"])
    Search.create(query: "Burgers", quotes: ["Burger First", "Burger Second"])

    get searches_url
    assert_response :success

    assert_includes @response.body, "Bacon First"
    assert_includes @response.body, "Bacon Second"
    assert_includes @response.body, "Burger First"
    assert_includes @response.body, "Burger Second"
  end

  test "should get search by id" do
    @search = Search.create(query: "Bacon", quotes: ["Bacon First", "Bacon Second"])

    get search_url(@search)
    assert_response :success

    assert_includes @response.body, "Bacon First"
    assert_includes @response.body, "Bacon Second"
  end

  test "should fail gracefully for a nonexistent id" do
    assert_raises ActiveRecord::RecordNotFound do
      get search_url(999_999)
    end
  end

  test "should return an existing search for a particular query" do
    @search = Search.create(query: "Bacon", quotes: ["Bacon First", "Bacon Second"])

    # Ensure our API service is never called in this case
    search_api = Minitest::Mock.new
    def search_api.search(query:); raise StandardError; end

    SwansonApi::Search.stub :new, search_api do
      post searches_url, params: { query: "Bacon" }
      assert_response :success

      assert_includes @response.body, "Bacon First"
      assert_includes @response.body, "Bacon Second"
    end
  end

  test "should create a new search for a nonexistent query" do
    # Stub the API service to avoid external calls in test
    search_api = Minitest::Mock.new
    def search_api.search(query:); Search.create(query: "Bacon", quotes: ["Bacon First", "Bacon Second"]); end

    SwansonApi::Search.stub :new, search_api do
      assert_equal Search.count, 0

      post searches_url, params: { query: "Bacon" }
      assert_response :success

      assert_equal Search.count, 1
      assert_includes @response.body, "Bacon First"
      assert_includes @response.body, "Bacon Second"
    end
  end
end
