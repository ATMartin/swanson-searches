require "test_helper"

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get searches_url
    assert_response :success
  end

  test "should get search by id" do
    @search = Search.create(query: "Bacon", quotes: ["Bacon First", "Bacon Second"])

    get search_url(@search)
    assert_response :success

    assert_includes @response.body, "Bacon First"
    assert_includes @response.body, "Bacon Second"
  end

  test "should fail gracefully for a nonexistent id" do
    get search_url(999_999)
    assert_response :not_found
  end
end
