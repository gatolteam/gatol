require 'test_helper'

class GameInstancesControllerTest < ActionController::TestCase
  setup do
    @game_instance = game_instances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_instances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_instance" do
    assert_difference('GameInstance.count') do
      post :create, game_instance: {  }
    end

    assert_redirected_to game_instance_path(assigns(:game_instance))
  end

  test "should show game_instance" do
    get :show, id: @game_instance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @game_instance
    assert_response :success
  end

  test "should update game_instance" do
    patch :update, id: @game_instance, game_instance: {  }
    assert_redirected_to game_instance_path(assigns(:game_instance))
  end

  test "should destroy game_instance" do
    assert_difference('GameInstance.count', -1) do
      delete :destroy, id: @game_instance
    end

    assert_redirected_to game_instances_path
  end
end
