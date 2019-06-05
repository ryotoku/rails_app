require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get static_pages_home_url
    assert_response :success
  end

  test "should get recommend" do
    get static_pages_recommend_url
    assert_response :success
  end

  test "should get popular" do
    get static_pages_popular_url
    assert_response :success
  end

end
