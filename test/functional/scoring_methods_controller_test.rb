require 'test_helper'

class ScoringMethodsControllerTest < ActionController::TestCase
  setup do
    @scoring_method = scoring_methods(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scoring_methods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create scoring_method" do
    assert_difference('ScoringMethod.count') do
      post :create, scoring_method: {  }
    end

    assert_redirected_to scoring_method_path(assigns(:scoring_method))
  end

  test "should show scoring_method" do
    get :show, id: @scoring_method
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @scoring_method
    assert_response :success
  end

  test "should update scoring_method" do
    put :update, id: @scoring_method, scoring_method: {  }
    assert_redirected_to scoring_method_path(assigns(:scoring_method))
  end

  test "should destroy scoring_method" do
    assert_difference('ScoringMethod.count', -1) do
      delete :destroy, id: @scoring_method
    end

    assert_redirected_to scoring_methods_path
  end
end
