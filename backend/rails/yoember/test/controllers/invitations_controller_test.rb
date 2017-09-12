require 'test_helper'
require 'json'

class InvitationsControllerTest < ActionController::TestCase
  test "Should get valid list of invitations" do
    get :index
    assert_response :success
    assert_equal response.content_type, 'application/vnd.api+json'
    jdata = JSON.parse response.body
    assert_equal 9, jdata['data'].length
    assert_equal jdata['data'][0]['type'], 'invitations'
    assert_equal ' © 2017 LugaTeX - TEST Project Public License (LPPL).', jdata['meta']['copyright']
  end

  test "Should get properly sorted list" do
    invitation = Invitation.order('email ASC').first
    assert_response :success
  end

  test "Should get valid invitation data" do
    invitation = invitations('invitation_1')
    get :show, params: { id: invitation.id }
    assert_response :success
    jdata = JSON.parse response.body
    assert_equal invitation.id.to_s, jdata['data']['id']
    assert_equal invitation.email, jdata['data']['attributes']['email']
    assert_equal invitation_url(invitation, { host: "localhost", port: 3000 }), jdata['data']['links']['self']
  end

  test "Should get JSON:API error block when requesting invitation data with invalid ID" do
    get :show, params: { id: "z" }
    assert_response :success
    jdata = JSON.parse response.body
    assert_equal "Couldn't find Invitation with 'id'=z", jdata['message']
    assert_equal ' © 2017 LugaTeX - TEST Project Public License (LPPL).', jdata['meta']['copyright']
    assert_equal 'CC-0', jdata['meta']['licence']
  end

  test "Creating new invitation without sending correct content-type should result in error" do
    post :create, params: {}
    assert_response 406
  end

  test "Creating new invitation with invalid type in JSON data should result in error" do
    invitation = invitations('invitation_1')
    post :create, params: { data: { type: 'posts' }}
    assert_response 406
  end

  test "Creating new invitation with invalid data should result in error" do
    invitation = invitations('invitation_1')
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    post :create, params: {
      data: {
        type: 'invitations',
        attributes: {
          email: nil
        }
      }
    }
    assert_response 422
    jdata = JSON.parse response.body
    pointers = jdata['errors'].collect { |e| e['source']['pointer'].split('/').last}.sort
    assert_equal ["email", "email", "email"], pointers
    # assert_response 200
    # assert_equal ["can't be blank", "is too short (minimum is 5 characters)", "is invalid"], jdata['email']
  end

  test "Creating new invitation with valid data should create new invitation" do
    invitation = invitations('invitation_1')
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    post :create, params: {
      data: {
        type: 'invitations',
        attributes: {
          email: 'invitation_10@example.com'
        }
      }
    }
    assert_response 200
    jdata = JSON.parse response.body
    assert_equal 'invitation_10@example.com'.downcase, jdata['data']['attributes']['email']
  end

  test "Updating an existing invitation with valid data should update that invitation" do
    invitation = invitations('invitation_1')
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    patch :update, params: {
      id: invitation.id,
      data: {
        id: invitation.id,
        type: 'invitations',
        attributes: {
          email: 'invitation_9@example.com'
        }
      }
    }
    assert_response 200
    jdata = JSON.parse response.body
    assert_equal 'invitation_9@example.com'.downcase, jdata['data']['attributes']['email']
    assert_equal ' © 2017 LugaTeX - TEST Project Public License (LPPL).', jdata['meta']['copyright']
    assert_equal 'CC-0', jdata['meta']['licence']
  end

  test "Should delete invitation" do
    invitation = invitations('invitation_1')
    ucount = Invitation.count - 1
    delete :destroy, params: { id: invitations('invitation_5').id }
    assert_response 200
    assert_equal ucount, Invitation.count
    jdata = JSON.parse response.body
    assert_equal "The invitation has been deleted", jdata['message']
    assert_equal ' © 2017 LugaTeX - TEST Project Public License (LPPL).', jdata['meta']['copyright']
    assert_equal 'CC-0', jdata['meta']['licence']
  end
end
