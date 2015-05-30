require 'test_helper'

class CheckControllerTest < ActionController::TestCase
  test "should get theme_page" do
    get :theme_page
    assert_response :success
  end

  test "should get article_page" do
    get :article_page
    assert_response :success
  end

  test "should get sistrix" do
    get :sistrix
    assert_response :success
  end

  test "should get searchmetrics" do
    get :searchmetrics
    assert_response :success
  end

end
