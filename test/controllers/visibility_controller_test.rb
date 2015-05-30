require 'test_helper'

class VisibilityControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get searchmetrics_page" do
    get :searchmetrics_page
    assert_response :success
  end

  test "should get sistrix_page" do
    get :sistrix_page
    assert_response :success
  end

end
