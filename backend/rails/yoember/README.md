> Building a complex web application

```
rails new yoember --api --skip-git --skip-keeps --skip-action-mailer --skip-action-cable

rails g resource Invitation email

rails g controller Invitations
rails g controller Errors

rake test
bundle exec rspec
bundel exec cucumber
```

> Test it out

```
$ curl -I -v http://api.dev.local:3000
$ curl -I --trace-ascii - http://api.dev.local:3000

$ curl http://api.dev.local:3000 | jq '.'
$ curl http://api.dev.local:3000 | python -m json.tool

$ curl http://api.dev.local:3000
$ curl http://api.dev.local:3000/invitations
$ curl http://api.dev.local:3000/invitations/1
$ curl http://api.dev.local:3000/invitations/2
$ curl http://api.dev.local:3000/invitations/3

# create new item
$ curl -i -H "Accept: application/vnd.api+json" \
        -H 'Content-Type:application/vnd.api+json' \
        -X POST \
        -d '{"data": {"type":"invitations", "attributes":{"email": "test@example.com"}}}' \
        http://localhost:3000/invitations

# update has been created item
$ curl -i -H "Accept: application/vnd.api+json" \
        -H 'Content-Type:application/vnd.api+json' \
        -X PUT \
        -d '{"email": "oleg@example.com"}' \
        http://localhost:3000/invitations/4

# destroy item
$ curl -i -H "Accept: application/vnd.api+json" \
        -H 'Content-Type:application/vnd.api+json' \
        -X DELETE \
        http://localhost:3000/invitations/4
```
> Modern command line HTTP client – httpie

```
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

> Which Ember Data Serializer Should I Use?

A serializer in Ember Data is used to massage data as it is transferred
between the client and the persistence layer. This includes manipulating
attribute values, normalizing property names, serializing relationships,
and adjusting the structure of request payloads and responses. Ember
Data comes with a few serializers:

1. `DS.JSONSerializer`
2. `DS.RESTSerializer`
3. `DS.JSONAPISerializer`
4. `DS.Serializer`

Which one should you use? The answer is, choose the one that fits your
API data format, or is as close to it as possible. But what format do
each of these serializers expect? Let’s find out.

**JSONSerializer**

*JSONSerializer*, not to be confused with *JSONAPISerializer*, is a
serializer that can be used for APIs that simply send the data back and
forth without extra meta information. For example, let’s say I make a
request to `/api/users/8`. The expected JSON response is:

```
{ "id": 8, "first": "David", "last": "Tang" }
```

The response is very flat and only contains the data. The data isn’t
nested under any keys like `data` as you often find with other APIs and
there is no metadata. Similarly, if you are creating, updating, and
deleting records, respond with the record that was created, modified, or
deleted: `{ "id": 99, "first": "David", "last": "Tang" }`.

What about endpoints like `/api/users`  that return arrays? As you’d
probably guess, the expected response contains just the array of users:

```
[
  { "id": 8, "first": "David", "last": "Tang" },
  { "id": 9, "first": "Jane", "last": "Doe" }
]
```

If your model is related to other models with `hasMany` and `belongsTo`
relationships:

```
export default DS.Model.extend({
  first: DS.attr('string'),
  last: DS.attr('string'),
  pets: DS.hasMany('pet', { async: true }),
  company: DS.belongsTo('company', { async: true })
});
```

then your JSON response would look like:

```
{
  "id": 99,
  "first": "David",
  "last": "Tang",
  "pets": [ 1, 2, 3 ],
  "company": 7
}
```

The `pets` and `company` attributes contains the unique identifiers for
each individual pet and company respectively. Ember Data will
asynchronously load these related models when you need them, such as
asking for them in your template.

**RESTSerializer**

The *RESTSerializer* differs from the *JSONSerializer* in that it
introduces an extra key in the response that matches the model name.
For example, if a request is made to `/api/users/8`, the expected JSON
response is:

```
{
  "user": {
    "id": 8,
    "first": "David",
    "last": "Tang",
    "pets": [ 1, 2, 3 ],
    "company": 7
  }
}
```

The root key is `user` and matches the model name. Similarly if a
request is made to `/api/users`, the expected JSON response is:

```
{
  "users": [
    {
      "id": 8,
      "first": "David",
      "last": "Tang",
      "pets": [ 1, 2, 3 ],
      "company": 7
    },
    {
      "id": 9,
      "first": "Jane",
      "last": "Doe",
      "pets": [ 4 ],
      "company": 7
    }
  ]
}
```

This time the root key, `users`, is the plural of the model name since
an array is being returned. It can also be in the singular form. Both
work, but I tend to use the model name in its plural form for array
responses and in its singular form for single object responses.

In the previous `users` example using the *JSONSerializer*, `pets` and
`company` were asynchronously loaded from the server. One of the
benefits of using the *RESTSerializer*  is that it supports
sideloading of data, which allows us to embed related records in the
response of the primary data requested. For example, when a request is
made to `/api/users/8`, a response with sideloaded data would look like:

```
{
  "user": {
    "id": 8,
    "first": "David",
    "last": "Tang",
    "pets": [ 1, 3 ],
    "company": 7
  },
  "pets": [
    { "id": 1, "name": "Fiona" },
    { "id": 3, "name": "Biscuit" }
  ],
  "companies": [
    { "id": 7, "name": "Company A" }
  ]
}
```

The response has keys `pets` and `companies` that correspond to the
sideloaded data. This was not possible with the *JSONSerializer*.
Using sideloaded data also enables you to make your model relationships
synchronous:

```
export default DS.Model.extend({
  first: DS.attr('string'),
  last: DS.attr('string'),
  pets: DS.hasMany('pet', { async: false }),          // synchronous
  company: DS.belongsTo('company', { async: false })  // synchronous
});
```

If you wanted your relationships to be synchronous with the
*JSONSerializer*, you would need to make sure that all companies
and pets were in the store prior to requesting the user.

**JSONAPISerializer**

### August 2017 Oleg G.Kapranov
