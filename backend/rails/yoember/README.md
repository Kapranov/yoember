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

> "Do not test APIs with Capybara. It wasn’t designed for it."
> - Jonas Nicklas

Instead, use Rack::Test, rather than the Capybara internals.

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

> Usage `open-uri`

```
# http://ruby-doc.org/stdlib-2.0.0/libdoc/open-uri/rdoc/OpenURI.html
require 'open-uri'

# Go fetch the contents of a URL & store them as a String
response = open('http://127.0.0.1:3000').read

# "Pretty prints" the result to look like a web page instead of one
# long string of HTML
URI.parse(response).class

# Print the contents of the website to the console
puts "\n\n#{response.inspect}\n\n"
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

*JSONAPISerializer* is the last serializer and it expects data to adhere
to the [JSON API specification][1]. For an endpoint that returns a
single object, like `/api/users/8`, a JSON API compliant response would
be:

```
{
  "data": {
    "type": "users",
    "id": "8",
    "attributes": {
      "first": "David",
      "last": "Tang"
    }
  }
}
```

The `attributes` property contains the data, the `type` property
contains the plural form of the model name, and the `id` property
contain the model’s id. One thing to note is that attributes need
to be dash-cased. If our attribute was `firstName` instead of `first`,
the attribute key name would need to be `first-name`.

For an endpoint that returns an array of objects, such as `/api/users`,
a JSON API compliant response would be:

```
{
  "data": [
    {
      "type": "users",
      "id": "8",
      "attributes": {
        "first": "David",
        "last": "Tang"
      }
    },
    {
      "type": "users",
      "id": "9",
      "attributes": {
        "first": "Jane",
        "last": "Doe"
      }
    }
  ]
}
```

Again, there is a `data` key but this time it contains an array. Each
element in the array matches the same structure as when fetching a
single resource. That is, an object with keys `type`, `id`, and
`attributes`.

What about relationships? To handle the `hasMany` pet relationship when
a user is requested, this is the expected JSON API structure:

```
{
  "data": {
    "type": "users",
    "id": "8",
    "attributes": {
      "first": "David",
      "last": "Tang"
    },
    "relationships": {
      "pets": {
        "data": [
          { "id": 1, "type": "pets" },
          { "id": 3, "type": "pets" }
        ]
      }
    }
  }
}
```

As you can see, there is a `relationships` object in the primary
`data` object. This example just shows the `pets` relationship but
you can have as many as you need in the `relationships` object. If
you look carefully at `data.relationships.pets.data`, each element
in the array is not the `pet` definition. It simply contains the
`id` and the `type`.

Lastly, what about sideloading data?

```
{
  "data": {
    "type": "users",
    "id": "8",
    "attributes": {
      "first": "David",
      "last": "Tang"
    },
    "relationships": {
      "pets": {
        "data": [
          { "id": 1, "type": "pets" },
          { "id": 3, "type": "pets" }
        ]
      }
    }
  },
  "included": [
    {
      "type": "pets",
      "id": "1",
      "attributes": {
        "name": "Fiona"
      }
    },
    {
      "type": "pets",
      "id": "3",
      "attributes": {
        "name": "Biscuit"
      }
    }
  ]
}
```

The `included` key is used for sideloading data and contains an array of
all related data. User 8 has 2 pets declared under `relationships`. The
data in the `included` array contains the associated records using the
same object structure for a single resource (having keys for `type`,
`id`, and `attributes`).

Even though JSON API seems a little verbose, I like that there is a
documented specification so that those who use it can have a common
understanding of their API data structure. This is particularly useful
in large teams. There is a lot more to JSON API, so check out the
specification for more information.

**Serializer**

*DS.Serializer* is an abstract class that *RESTSerializer*,
*JSONSerializer*, and *JSONAPISerializer* extend from. As mentioned in
the Ember Guides, you would use this serializer if your API is wildly
different and one of the other serializers cannot be used. Personally I
haven’t found myself in a situation where I’ve needed to do this, and
hopefully you don’t either!

**Conclusion**

There is a lot more to these serializers, especially the
*JSONAPISerializer*, but hopefully this helped point you in the right
direction. To work efficiently with Ember Data, figure out what
structure your API data is in and choose the serializer that best
matches it. If you are starting from scratch and you have control over
your API, try and go with a format that one of the serializers expects
so that you don’t have to massage your data too much. Also, following
the expected format for one of the serializers makes it that much easier
for other developers to hop onto your project. Hopefully this provided a
good overview of what is expected by each serializer so you can easily
determine which one fits your project’s needs.

Interested in learning more about Ember Data and how to use it with any
API? Check out the book [Ember Data in the Wild - Getting Ember Data to
Work With Your API][2] and [source code][3] from book.

### September 2017 Oleg G.Kapranov

[1]:  http://jsonapi.org/
[2]:  https://leanpub.com/emberdatainthewild
[3]:  https://github.com/skaterdav85/ember-data-in-the-wild
[4]:  http://thejsguy.com/
[5]:  https://github.com/taf2/curb
[6]:  http://www.betterspecs.org/
[7]:  https://relishapp.com/rspec/rspec-rails/v/3-6/docs
[8]:  https://github.com/thoughtbot/shoulda-matchers
[9]:  https://github.com/jdliss/shoulda-callback-matchers
[10]: http://api.rubyonrails.org/v5.1/
[11]: http://apionrails.icalialabs.com
[12]: https://github.com/eliotsykes/rspec-rails-examples
[13]: https://github.com/evrone/factory_girl-seeds
[14]: https://github.com/ruby-json-schema/json-schema
[15]: https://github.com/thoughtbot/json_matchers
[16]: https://robots.thoughtbot.com/validating-json-schemas-with-an-rspec-matcher
[17]: http://www.amielmartin.com/blog/2017/08/31/how-ember-data-loads-async-relationships
[18]: https://spacetelescope.github.io/understanding-json-schema/index.html
[19]: https://brandur.org/elegant-apis
