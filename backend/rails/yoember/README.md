> Building a complex web application

```
rails new yoember --api --skip-git --skip-keeps --skip-action-mailer --skip-action-cable

rails g resource Invitation email

rails g controller Invitations
rails g controller Errors

rake test
bundle exec rspec
bundel exec cucumber

curl -I -v http://api.dev.local:3000
curl -I --trace-ascii - http://api.dev.local:3000

curl http://api.dev.local:3000 | jq '.'
curl http://api.dev.local:3000 | python -m json.tool

curl http://api.dev.local:3000
curl http://api.dev.local:3000/invitations
curl http://api.dev.local:3000/invitations/1
curl http://api.dev.local:3000/invitations/2
curl http://api.dev.local:3000/invitations/3

# create new item
curl -i -H "Accept: application/vnd.api+json" \
        -H 'Content-Type:application/vnd.api+json' \
        -X POST \
        -d '{"data": {"type":"invitations", "attributes":{"email": "test@example.com"}}}' \
        http://localhost:3000/invitations

# update has been created item
curl -i -H "Accept: application/vnd.api+json" \
        -H 'Content-Type:application/vnd.api+json' \
        -X PUT \
        -d '{"email": "oleg@example.com"}' \
        http://localhost:3000/invitations/4

# destroy item
curl -i -H "Accept: application/vnd.api+json" \
        -H 'Content-Type:application/vnd.api+json' \
        -X DELETE \
        http://localhost:3000/invitations/4


# Modern command line HTTP client – httpie
http :3000

# GET /invitations
$ http :3000/invitations

# GET /invitations/:id
$ http :3000/invitations/4

# POST /invitations
$ http POST :3000/invitations <<<'{"data": {"type":"invitations", "attributes":{"email": "lugatex@example.com"}}}'

# PUT /invitations/:id
$ http PUT :3000/invitations/4 email="oleg@example.com"

# DELETE /invitations/:id
$ http DELETE :3000/invitations/1
```

### August 2017 Oleg G.Kapranov
