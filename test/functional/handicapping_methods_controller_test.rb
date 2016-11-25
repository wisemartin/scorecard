require 'test_helper'

class HandicappingMethodsControllerTest < ActionController::TestCase
  setup do
    @handicapping_method = handicapping_methods(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:handicapping_methods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create handicapping_method" do
    assert_difference('HandicappingMethod.count') do
      post :create, handicapping_method: {  }
    end

    assert_redirected_to handicapping_method_path(assigns(:handicapping_method))
  end

  test "should show handicapping_method" do
    get :show, id: @handicapping_method
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @handicapping_method
    assert_response :success
  end

  test "should update handicapping_method" do
    put :update, id: @handicapping_method, handicapping_method: {  }
    assert_redirected_to handicapping_method_path(assigns(:handicapping_method))
  end

  test "should destroy handicapping_method" do
    assert_difference('HandicappingMethod.count', -1) do
      delete :destroy, id: @handicapping_method
    end

    assert_redirected_to handicapping_methods_path
  end
end
