require 'test_helper'

class GameTemplatesControllerTest < ActionController::TestCase
  setup do
    @game_template = game_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_template" do
    assert_difference('GameTemplate.count') do
      post :create, game_template: {  }
    end

    assert_redirected_to game_template_path(assigns(:game_template))
  end

  test "should show game_template" do
    get :show, id: @game_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @game_template
    assert_response :success
  end

  test "should update game_template" do
    patch :update, id: @game_template, game_template: {  }
    assert_redirected_to game_template_path(assigns(:game_template))
  end

  test "should destroy game_template" do
    assert_difference('GameTemplate.count', -1) do
      delete :destroy, id: @game_template
    end

    assert_redirected_to game_templates_path
  end
end
