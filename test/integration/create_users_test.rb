require 'test_helper'

class CreateUsersTest < ActionDispatch::IntegrationTest

  test 'get signup page and create user' do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { username: 'john', email: 'john@example.com', password: 'password' }
    end

    assert_template 'users/show'
    user = User.last
    assert user.username == 'john'
    assert user.email == 'john@example.com'
    assert user.authenticate('password')

    get users_path
    assert_template 'users/index'
    assert_match user.username, response.body
  end

  test 'invalid user submission results in failure' do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post users_path, user: { username: ' ', email: ' ', password: ' ', admin: false}
    end

    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

end

