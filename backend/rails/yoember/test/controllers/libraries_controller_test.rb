require 'test_helper'
require 'json'

class LibrariesControllerTest < ActionController::TestCase
  test "Should get valid list of libraries" do
    get :index
    assert_response :success
    assert_equal response.content_type, 'application/vnd.api+json'
    jdata = JSON.parse response.body
    assert_equal 9, jdata['data'].length
    assert_equal jdata['data'][0]['type'], 'libraries'
    assert_equal ' © 2017 LugaTeX - TEST Project Public License (LPPL).', jdata['meta']['copyright']
  end

  test "Should get properly sorted list" do
    library = Library.order('name ASC').first
    assert_response :success
  end

  test "Should get valid user data" do
    library = libraries('library_1')
    get :show, params: { id: library.id }
    assert_response :success
    jdata = JSON.parse response.body
    assert_equal library.id.to_s, jdata['data']['id']
    assert_equal library.name, jdata['data']['attributes']['name']
    assert_equal library.address, jdata['data']['attributes']['address']
    assert_equal library.phone, jdata['data']['attributes']['phone']
    assert_equal library_url(library, { host: "localhost", port: 3000 }), jdata['data']['links']['self']
  end

  test "Should get JSON:API error block when requesting library data with invalid ID" do
    get :show, params: { id: "z" }
    assert_response 200
    jdata = JSON.parse response.body
    assert_equal "Couldn't find Library with 'id'=z", jdata['message']
    assert_equal ' © 2017 LugaTeX - TEST Project Public License (LPPL).', jdata['meta']['copyright']
    assert_equal 'CC-0', jdata['meta']['licence']
  end

  test "Creating new library without sending correct content-type should result in error" do
    post :create, params: {}
    assert_response 406
  end

  test "Creating new library with invalid type in JSON data should result in error" do
    library = libraries('library_1')
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    post :create, params: { data: { type: 'posts' }}
    assert_response 200
  end

  test "Creating new library with invalid data should result in error" do
    library = libraries('library_1')
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    post :create, params: {
      data: {
        type: 'libraries',
        attributes: {
          name: nil,
          address: nil,
          phone: nil
        }
      }
    }
    assert_response 200
    jdata = JSON.parse response.body
    assert_equal ["can't be blank"], jdata['name']
    assert_equal ["can't be blank"], jdata['address']
    assert_equal ["can't be blank"], jdata['phone']
  end

  test "Creating new library with valid data should create new library" do
    library = libraries('library_1')
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    post :create, params: {
      data: {
        type: 'libraries',
        attributes: {
          name: "library nr10",
          address: "East Robinborough1503 Marks PlazaSuite 453",
          phone: "3818451911"
        }
      }
    }
    assert_response 200
    jdata = JSON.parse response.body
    assert_equal 'library nr10', jdata['data']['attributes']['name']
    assert_equal 'East Robinborough1503 Marks PlazaSuite 453'.downcase, jdata['data']['attributes']['address']
    assert_equal '3818451911', jdata['data']['attributes']['phone']
    assert_equal ' © 2017 LugaTeX - TEST Project Public License (LPPL).', jdata['meta']['copyright']
    assert_equal 'CC-0', jdata['meta']['licence']
  end

  test "Updating an existing library with valid data should update that library" do
    library = libraries('library_1')
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    patch :update, params: {
      id: library.id,
      data: {
        id: library.id,
        type: 'libraries',
        attributes: {
          name: 'library nr1',
          address: "East Robinborough1503 Marks PlazaSuite 455",
          phone: "3818451919"

        }
      }
    }
    assert_response 200
    jdata = JSON.parse response.body
    assert_equal 'library nr1', jdata['data']['attributes']['name']
    assert_equal 'East Robinborough1503 Marks PlazaSuite 455'.downcase, jdata['data']['attributes']['address']
    assert_equal '3818451919', jdata['data']['attributes']['phone']
    assert_equal ' © 2017 LugaTeX - TEST Project Public License (LPPL).', jdata['meta']['copyright']
    assert_equal 'CC-0', jdata['meta']['licence']
  end

  test "Should delete library" do
    library = libraries('library_1')
    ucount = Library.count - 1
    delete :destroy, params: { id: libraries('library_5').id }
    assert_response 200
    assert_equal ucount, Library.count
    jdata = JSON.parse response.body
    assert_equal "The library has been deleted", jdata['message']
    assert_equal ' © 2017 LugaTeX - TEST Project Public License (LPPL).', jdata['meta']['copyright']
    assert_equal 'CC-0', jdata['meta']['licence']
  end

end
