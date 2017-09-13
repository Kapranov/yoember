require 'test_helper'
require 'json'

class ErrorsControllerTest < ActionController::TestCase
  test "#404 page" do
    get :not_found
    assert_response :success
    assert_equal response.content_type, 'application/vnd.api+json'
    jdata = JSON.parse response.body
    assert_equal ["Not Found"], jdata['errors']
    assert_equal ' © 2017 LugaTeX - TEST Project Public License (LPPL).', jdata['meta']['copyright']
    assert_equal 'CC-0', jdata['meta']['licence']
  end

  test "#422 page" do
    get :unacceptable
    assert_response :success
    assert_equal response.content_type, 'application/vnd.api+json'
    jdata = JSON.parse response.body
    assert_equal ["Unprocessable Entity"], jdata['errors']
    assert_equal ' © 2017 LugaTeX - TEST Project Public License (LPPL).', jdata['meta']['copyright']
    assert_equal 'CC-0', jdata['meta']['licence']
  end

  test "#500 page" do
    get :internal_server_error
    assert_response :success
    assert_equal response.content_type, 'application/vnd.api+json'
    jdata = JSON.parse response.body
    assert_equal ["Internal Server Error"], jdata['errors']
    assert_equal ' © 2017 LugaTeX - TEST Project Public License (LPPL).', jdata['meta']['copyright']
    assert_equal 'CC-0', jdata['meta']['licence']
  end
end
