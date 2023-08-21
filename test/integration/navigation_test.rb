require "test_helper"

class NavigationTest < ActionDispatch::IntegrationTest
  test "root will succeed" do
     get "/plain/docs"
     assert_response :success
  end

  test "access intro" do
    get "/plain/docs/getting_started/intro"
    assert_response :success
  end
end
