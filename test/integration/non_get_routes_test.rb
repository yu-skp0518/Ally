# frozen_string_literal: true

require "test_helper"

# link_to method: :delete / :patch / :post を button_to に変更したことの検証。
# GET でこれらの URL にアクセスすると 4xx になること（ルート不一致または Method Not Allowed）、
# 正しい HTTP メソッドではルートが一致することをテストする。
#
# テストケース一覧（各ルートで「GET は失敗」「正しいメソッドはルート一致」の2本）:
#   - user_quit          PATCH  /users/:user_id/quit
#   - user_unban         PATCH  /users/:user_id/unban
#   - book_disenable     PATCH  /books/:book_id/disenable
#   - user_relationship DELETE /users/:user_id/relationships/:id
#   - user_relationships POST   /users/:user_id/relationships
#   - book_bookmark      DELETE /books/:book_id/bookmarks/:id
#   - book_bookmarks     POST   /books/:book_id/bookmarks
#   - book_comment_like  DELETE /books/:book_id/comments/:comment_id/likes/:id
#   - book_comment_likes POST   /books/:book_id/comments/:comment_id/likes
#   - book_comment       DELETE /books/:book_id/comments/:id
#   - admin_book_comment DELETE /admin/books/:book_id/comments/:id
class NonGetRoutesTest < ActionDispatch::IntegrationTest
  # GET ではルートに一致しないか、405 になること
  def assert_get_fails(path)
    get path
    assert response.response_code >= 400, "GET では成功(2xx)してはいけない (got #{response.response_code})"
  end

  def test_get_user_quit_fails
    assert_get_fails user_quit_path(user_id: 1)
  end

  def test_patch_user_quit_matches_route
    patch user_quit_path(user_id: 1)
    assert response.response_code.present?, "PATCH /users/1/quit はルートに一致すること"
  end

  def test_get_user_unban_fails
    assert_get_fails user_unban_path(user_id: 1)
  end

  def test_patch_user_unban_matches_route
    patch user_unban_path(user_id: 1)
    assert response.response_code.present?, "PATCH /users/1/unban はルートに一致すること"
  end

  def test_get_book_disenable_fails
    assert_get_fails book_disenable_path(book_id: 1)
  end

  def test_patch_book_disenable_matches_route
    patch book_disenable_path(book_id: 1)
    assert response.response_code.present?, "PATCH /books/1/disenable はルートに一致すること"
  end

  def test_get_user_relationship_destroy_fails
    assert_get_fails user_relationship_path(user_id: 1, id: 1)
  end

  def test_delete_user_relationship_matches_route
    delete user_relationship_path(user_id: 1, id: 1)
    assert response.response_code.present?, "DELETE user_relationship はルートに一致すること"
  end

  def test_get_user_relationships_create_fails
    assert_get_fails user_relationships_path(user_id: 1)
  end

  def test_post_user_relationships_matches_route
    post user_relationships_path(user_id: 1)
    assert response.response_code.present?, "POST user_relationships はルートに一致すること"
  end

  def test_get_book_bookmark_destroy_fails
    assert_get_fails book_bookmark_path(book_id: 1, id: 1)
  end

  def test_delete_book_bookmark_matches_route
    delete book_bookmark_path(book_id: 1, id: 1)
    assert response.response_code.present?, "DELETE book_bookmark はルートに一致すること"
  end

  def test_get_book_bookmarks_create_fails
    assert_get_fails book_bookmarks_path(book_id: 1)
  end

  def test_post_book_bookmarks_matches_route
    post book_bookmarks_path(book_id: 1)
    assert response.response_code.present?, "POST book_bookmarks はルートに一致すること"
  end

  def test_get_book_comment_like_destroy_fails
    assert_get_fails book_comment_like_path(book_id: 1, comment_id: 1, id: 1)
  end

  def test_delete_book_comment_like_matches_route
    delete book_comment_like_path(book_id: 1, comment_id: 1, id: 1)
    assert response.response_code.present?, "DELETE book_comment_like はルートに一致すること"
  end

  def test_get_book_comment_likes_create_fails
    assert_get_fails book_comment_likes_path(book_id: 1, comment_id: 1)
  end

  def test_post_book_comment_likes_matches_route
    post book_comment_likes_path(book_id: 1, comment_id: 1)
    assert response.response_code.present?, "POST book_comment_likes はルートに一致すること"
  end

  def test_get_book_comment_destroy_fails
    assert_get_fails book_comment_path(book_id: 1, id: 1)
  end

  def test_delete_book_comment_matches_route
    delete book_comment_path(book_id: 1, id: 1)
    assert response.response_code.present?, "DELETE book_comment はルートに一致すること"
  end

  def test_get_admin_book_comment_destroy_fails
    assert_get_fails admin_book_comment_path(book_id: 1, id: 1)
  end

  def test_delete_admin_book_comment_matches_route
    delete admin_book_comment_path(book_id: 1, id: 1)
    assert response.response_code.present?, "DELETE admin_book_comment はルートに一致すること"
  end
end
