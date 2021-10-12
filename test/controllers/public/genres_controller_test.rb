require 'test_helper'

class Public::GenresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_genres_index_url
    assert_response :success
  end

  test "should get update" do
    get public_genres_update_url
    assert_response :success
  end

end
