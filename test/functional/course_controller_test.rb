require 'test_helper'

class CourseControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get list" do
    get :list
    assert_response :success
  end

end
