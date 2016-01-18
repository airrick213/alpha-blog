require 'test_helper'

class CreateArticlesTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(username: 'john',
                        email: 'john@example.com',
                        password: 'password',
                        admin: true)
    sign_in_as(@user, 'password')
  end

  test 'get new article form and create article' do
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post_via_redirect articles_path, article: { title: 'My Title', description: 'My description' }
    end

    assert_template 'articles/show'
    assert_match 'My Title', response.body
    assert_match 'My description', response.body
  end

  test 'invalid article criteria results in failure' do
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post articles_path, article: { title: ' ', description: ' ' }
    end

    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

end

