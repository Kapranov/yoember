## Building a complex web application with Ember.js 2.15

This application uses the latest Ember CLI tool (v2.15.1).

* Creating our first static page with Ember.js
  * Add Bootstrap and Sass to Ember.js App
* Computed property, actions, dynamic content
* Models, saving data in database
* Deploy your app and add more CRUD functionality
* Data down actions up, using components
* Advance model structures and data relationships
* CRUD interface for Authors and Books, managing model relationship

### Prerequisites

* Node.js: at least v4, but the best if you install the latest long term
  support version (v6) or the current version (v7).
* Ember Inspector Chrome Extension
* (Optional but suggested on Mac and Linux) Watchman from Facebook
  Watchman increases the speed of the build process significantly.

### Install Ember CLI

Node version, npm version and OS version may be different in your
configuration.

```
npm install -g ember-cli
ember -v

ember-cli: 2.15.1
node: 8.2.1
os: linux x64
```

[Read more about Ember CLI here][1]

### Create the application

```
ember new yoember
ember server
```

[Open your new empty app in your browser][2]

```
ember generate template application
echo '<h1>Welcome to Ember</h1>' > app/templates/application.hbs
```

### Turn on a few debugging options

```
// config/environment.js
//..
if (environment === 'development') {
  // ENV.APP.LOG_RESOLVER = true;
  ENV.APP.LOG_ACTIVE_GENERATION = true;
  ENV.APP.LOG_TRANSITIONS = true;
  ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
  ENV.APP.LOG_VIEW_LOOKUPS = true;
}
//..
```
Check your app and open the Console in Chrome/Firefox. You will see some
extra information about what Ember.js actually does under the hood.

### Add Bootstrap and Sass

We use Bootstrap with Sass. Ember CLI can install for us add-ons and
useful packages. These add-ons simplify our development process, because
we don’t have to reinvent the wheel, we get more out of the box. You can
find various packages, add-ons on these websites: [emberaddons][3],
[emberobserver][4].

```
ember install ember-cli-sass
ember install ember-cli-bootstrap-sassy

mv app/styles/app.css app/styles/app.scss

echo '@import "bootstrap";' > app/styles/app.scss
```

### Create a navigation partial

We will use bootstrap navigation bar to create a nice header section for
our app.

```
<!-- app/templates/application.hbs -->
<div class="container">
  {{partial 'navbar'}}
  {{outlet}}
</div>
```

```
ember generate template navbar
```

```
<!-- app/templates/navbar.hbs -->
<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#main-navbar">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      {{#link-to 'index' class="navbar-brand"}}Library App{{/link-to}}
    </div>

    <div class="collapse navbar-collapse" id="main-navbar">
      <ul class="nav navbar-nav">
        {{#link-to 'index' tagName="li"}}<a href="">Home</a>{{/link-to}}
      </ul>
    </div>
  </div>
</nav>
```

You can update your `app.scss` file to add some extra padding to the
top.

```
<!-- app/styles/app.scss -->
@import "bootstrap";

body {
  padding-top: 20px;
}

html {
  overflow-y: scroll;
}

.library-item {
  min-height: 150px;
}
```

### Create a new About page and add the link to the menu bar

```
ember generate route about
ember generate route contact
ember generate template index
ember generate template contact

echo '<h1>About Page</h1>'   > app/templates/about.hbs
echo '<h1>Home Page</h1>'    > app/templates/index.hbs
echo '<h1>Contact Page</h1>' > app/templates/contact.hbs
```

Open `app/templates/navbar.hbs` and add the following line to the `ul`
section under the `Home` link:

```
<!-- app/templates/navbar.hbs -->

<ul class="nav navbar-nav">
  {{#link-to 'index' tagName="li"}}<a href="">Home</a>{{/link-to}}
  {{#link-to 'about' tagName="li"}}<a href="">About</a>{{/link-to}}
  {{#link-to 'contact' tagName="li"}}<a href="">Contact</a>{{/link-to}}
</ul>
```

### Homepage with an email input box

Let’s create a coming soon “jumbotron” on the home page with an email
input box, where users can subscribe for a newsletter.

* [Bootstrap’s jumbotron][6]
* [Bootstrap’s forms][7]

**Static html5 and style**

Add a static jumbotron, an input box and a button to
`app/templates/index.hbs`:

```
<!-- app/templates/index.hbs -->
<div class="jumbotron text-center">
  <h1>Coming Soon</h1>

  <br/><br/>

  <p>Don't miss our launch date, request an invitation now.</p>

  <div class="form-horizontal form-group form-group-lg row">
    <div class="col-xs-10 col-xs-offset-1 col-sm-6 col-sm-offset-1 col-md-5 col-md-offset-2">
      <input type="email" class="form-control" placeholder="Please type your e-mail address." autofocus="autofocus"/>
    </div>
    <div class="col-xs-10 col-xs-offset-1 col-sm-offset-0 col-sm-4 col-md-3">
      <button class="btn btn-primary btn-lg btn-block">Request invitation</button>
    </div>
  </div>

  <br/><br/>
</div>
```

We would like to cover the following requirements:

* “Invite me” button should be inactive when input box is empty.
* “Invite me” button should be inactive when the content in the input
  box is not a valid email address.
* Show a response message after clicking on “Invite me” button.
* Clear the input box after invitation has sent.

**isDisabled**

We can add dynamic values to standard html properties using
conditionals. We can use our controller to add or modify the value of a
variable, which we use in our template. Check the following solution.

We use a boolean variable, let’s call it `isDisabled`, which will help
us to turn on and off the `disable` html attribute on our button. We
have access to these variables in our controllers and in our templates.

From the official guide: "Each template has an associated controller:
this is where the template finds the properties that it displays. You
can display a property from your controller by wrapping the property
name in curly braces."

First, update your `index.hbs` template with this variable.
Add `disabled` property with `{{isDisabled}}` boolean variable.

```
ember g controller index
```

[Read more about Ember controllers][8]

```
<button disabled={{isDisabled}} class="btn btn-primary btn-lg btn-block">Request invitation</button>
```

Add `isDisabled` property to the controller. Default value is `true`.

```
//app/controllers/index.js
import Ember from 'ember';

export default Ember.Controller.extend({
  isDisabled: true
});
```

If you check app, you will see that the button is disabled by default.
We want to add some logic around this feature. We have to learn a couple
of new Ember.js features for that.

**Computed Properties and Observers**

Computed Properties and Observers are important features of Ember.js.

* [Computed Properties][9]
* [Observers][10]

Computed properties and observers still could be written in two ways,
however the classic syntax will be deprecated soon, but it is important
to know the “old” syntax and the “new” syntax, so when you see older
project, you will recognise this pattern.

Previously `.property()` and `.observes()` were attached to the end of
the functions. Nowadays we use `Ember.computed()` and `Ember.observer()`
functions instead. Let’s see in examples:

```
// Old (with ES5 string concatenation):
//...
fullName: function() {
  return this.get('firstName') + ' ' + this.get('lastName');
}.property('firstName', 'lastName')
//...
```

New (with ES6 string interpolation, which uses back-tick, dollar sign
and curly braces):

```
//...
fullName: Ember.computed('firstName', 'lastName', function() {
  return `${this.get('firstName')} ${this.get('lastName')}`;
})
//...
```

So, we will use this new syntax. `Ember.computed()` can have more
parameters. The first parameters are always variables/properties in
string format; what we would like to use inside our function.
The last parameter is a `function()`. Inside this function we will have
access to the properties with `this.get()`.
In Ember.js we read properties with `this.get('propertyName')` and
update properties with `this.set('propertyName', newValue)`.

Let’s update our html code with input component syntax and add a `value`
to our email input box.

Modify `<input>` line as follow in `index.hbs`:

```
{{input type="email" value=emailAddress class="form-control" placeholder="Please type your e-mail address." autofocus="autofocus"}}
```

As you can see, we use the `emailAddress` variable, or in other words,
a "property" where we would like to store the value of the input box.

If you type something in the input box, it will update this variable in
the controller as well.

You can use the following code in your controller to demonstrate the
differences between computed properties and observers:

```
//app/controllers/index.js
import Ember from 'ember';

export default Ember.Controller.extend({
  isDisabled: true,

  emailAddress: '',

  actualEmailAddress: Ember.computed('emailAddress', function() {
    console.log('actualEmailAddress function is called: ', this.get('emailAddress'));
  }),

  emailAddressChanged: Ember.observer('emailAddress', function() {
    console.log('observer is called', this.get('emailAddress'));
  })
});
```

Observers will always be called when the value of the `emailAddress`
changes, while the computed property only changes when you go and use
that property. Open app in your browser, and activate Ember Inspector.
Click on `/# Routes` section, find the `index` route, and in the same
line, under the `Controller` column, you will see an `>$E` sign; click
on it. Open the console in Chrome and you will see something like this:
`Ember Inspector ($E): Class {__nextSuper: undefined, __ember_meta__:
Object, __ember1442491471913: "ember443"}`

If you type the following in the console:
`$E.get('actualEmailAddress')`, you should see the console.log output
message defined above inside “actualEmailAddress”. You can try out
`$E.set('emailAddress', 'example@example.com')`  in the console.

**isDisabled with Computed Property**

We can rewrite our `isDisabled` with computed property as well.

```
// app/controllers/index.js
import Ember from 'ember';

export default Ember.Controller.extend({
  emailAddress: '',

  isDisabled: Ember.computed('emailAddress', function() {
    return this.get('emailAddress') === '';
  })
});
```

There are a few predefined computed property functions, which saves you
some code. In the following example we use `Ember.computed.empty()`,
which checks whether a property is empty or not.

```
// app/controllers/index.js
import Ember from 'ember';

export default Ember.Controller.extend({
  emailAddress: '',

  isDisabled: Ember.computed.empty('emailAddress')
});
```

More about `Ember.computed` short syntax: [Check all the methods][11]

**isValid**

Let’s go further. It would be a more elegant solution if we only enabled
our “Request Invitation” button when the input box contained a valid
email address. We’ll use the `Ember.computed.match()` short computed
property function to check the validity of the string. But `isDisabled`
needs to be the negated version of this `isValid` computed property. We
can use the `Ember.computed.not()` for this:

```
// app/controllers/index.js
import Ember from 'ember';

export default Ember.Controller.extend({
  emailAddress: '',

  isValid: Ember.computed.match('emailAddress', /^.+@.+\..+$/),
  isDisabled: Ember.computed.not('isValid')

});
```

Great, it works now as expected. You see, we can write really elegant
code with Ember.js, can’t we? ;)

**Adding Actions**

Great we have an input box and a button on our screen, but it does
nothing at the moment. Let’s implement our first action.

Update the `<button>` line in `index.hbs` to read like this.

```
<button class="btn btn-primary btn-lg btn-block" disabled={{isDisabled}} {{action 'saveInvitation'}}>Request invitation</button>
```

You can try it out in browser and see that if you click on the button,
you will get a nice error message, alerting you that you have to
implement this action in your controller. Let’s do that.

```
// app/controllers/index.js
import Ember from 'ember';

export default Ember.Controller.extend({
  emailAddress: '',

  isValid: Ember.computed.match('emailAddress', /^.+@.+\..+$/),
  isDisabled: Ember.computed.not('isValid'),

  actions: {
    saveInvitation() {
      alert(`Saving of the following email address is in progress: ${this.get('emailAddress')}`);
      this.set('responseMessage', `Thank you! We've just saved your email address: ${this.get('emailAddress')}`);
      this.set('emailAddress', '');
    }
  }
});
```

If click on the button, the `saveInvitation` action is called and shows
an alert box, sets up a `responseMessage` property, and finally deletes
the content of emailAddress`.

We have to show the response message. Extend your template.

```
<!-- app/templates/index.hbs -->
<div class="jumbotron text-center">
  <h1>Coming Soon</h1>

  <br/><br/>

  <p>Don't miss our launch date, request an invitation now.</p>

  <div class="form-horizontal form-group form-group-lg row">
    <div class="col-xs-10 col-xs-offset-1 col-sm-6 col-sm-offset-1 col-md-5 col-md-offset-2">
      {{input type="email" value=emailAddress class="form-control" placeholder="Please type your e-mail address." autofocus="autofocus"}}
    </div>
    <div class="col-xs-10 col-xs-offset-1 col-sm-offset-0 col-sm-4 col-md-3">
      <button class="btn btn-primary btn-lg btn-block" {{action 'saveInvitation'}} disabled={{isDisabled}}>Request invitation</button>
    </div>
  </div>

  {{#if responseMessage}}
    <div class="alert alert-success">{{responseMessage}}</div>
  {{/if}}

  <br/><br/>
</div>
```
We use the `{{#if}}{{/if}}` handlebar helper block to show or hide the
alert message. Handlebar conditionals are really powerful. You can use
`{{else}}` as well.

[More about conditionals in templates]:[5]

**Contact page**

* In this contact form will be two fields; one field for an email
  address and another field for a text message.
* There will be a “Send message” button.
* This button should be active only if the email address field isn’t
  empty and is valid, and there is some message in the text box.
* After clicking on the “Send message” button, an alert should appear
  with the email address and the message.
* When you close the alert message, the form should be cleared and a
  success message should appear on the page in a green box. This message
  could be something like, "We got your message and we’ll get in touch
  soon".

### Models

The model detailed introduction on [Ember.js Models][12]

```
ember g model contact email:string message:string
ember g model invitation email:string
ember g model library name:string address:string phone:string
```

```
// app/models/invitation.js
import DS from 'ember-data';

export default DS.Model.extend({
  email: DS.attr('string')
});
```

```
// app/models/library.js
import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  name: DS.attr('string'),
  address: DS.attr('string'),
  phone: DS.attr('string'),

  isValid: Ember.computed.notEmpty('name')
});
```

```
// app/models/contact.js
import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  email: DS.attr('string'),
  message: DS.attr('string'),

  isValidEmail: Ember.computed.match('email', /^.+@.+\..+$/),
  isMessageEnoughLong: Ember.computed.gte('message.length', 5),

  isValid: Ember.computed.and('isValidEmail', 'isMessageEnoughLong'),
  isNotValid: Ember.computed.not('isValid')
});
```

Update `app/controllers/index.js` controller action. Instead of showing
a useless alert message, we try to save our data.

```
// app/controllers/index.js
import Ember from 'ember';

export default Ember.Controller.extend({
  headerMessage: 'Coming Soon',
  responseMessage: '',
  emailAddress: '',

  isValid: Ember.computed.match('emailAddress', /^.+@.+\..+$/),
  isDisabled: Ember.computed.not('isValid'),

  actions: {
    saveInvitation() {
      const email = this.get('emailAddress');

      const newInvitation = this.store.createRecord('invitation', { email: email });
      newInvitation.save();

      newInvitation.save().then((response) => {
        this.set('responseMessage', `Thank you! We saved your email address with the following id: ${response.get('id')}`);
        this.set('emailAddress', '');
      });
    }
  }
});
```

Templates:

```
<!-- app/templates/contact.hbs -->
<h1>Contact Page</h1>

<p class="well well-sm">If you have any question or feedback please leave a message with your email address.</p>

<div class="row">
  <div class="col-md-6">

    {{#if responseMessage}}

      <br/>
      <div class="alert alert-success">
        <h4>Thank you! Your message is sent.</h4>
        <p>To: {{model.email}}</p>
        <p>Message: {{model.message}}</p>
        <p>Reference ID: {{model.id}}</p>
      </div>

    {{else}}

      <div class="form-group has-feedback {{if model.isValidEmail 'has-success'}}">
        <label>Your email address*:</label>
        {{input type="email" class="form-control" placeholder="Your email address" value=model.email autofocus="autofocus"}}
        {{#if model.isValidEmail}}<span class="glyphicon glyphicon-ok form-control-feedback"></span>{{/if}}
      </div>

      <div class="form-group has-feedback {{if model.isMessageEnoughLong 'has-success'}}">
        <label>Your message*:</label>
        {{textarea class="form-control" placeholder="Your message. (At least 5 characters.)" rows="5" value=model.message}}
        {{#if model.isMessageEnoughLong}}<span class="glyphicon glyphicon-ok form-control-feedback"></span>{{/if}}
      </div>

      <button class="btn btn-success" {{action 'sendMessage' model}} disabled={{model.isNotValid}}>Send</button>

    {{/if}}

  </div>
</div>
```

Open the app in the browser, and open the browser’s console.
Try to save an invitation email address on the home page.
You will see an error message in the console.

Ember.js tried to send that data to a server, but we don’t have a server
yet. Let’s build one.

**Setup a server on Ruby on Rails vs. Elixir/Phoenix**

Please see directory ``yoember/tree/master/backend``

We can configure the URL of your backend inside the application
[adapter][13]. So run:

```
ember generate adapter application
```

to generate it and make it look like this:

```
// app/adapters/application.js
export default DS.ActiveModelAdapter.extend({
});
```
Edit `app/adapters/application.js`:

```
// app/adapters/application.js
import Ember from 'ember';
import JSONAPIAdapter from 'ember-data/adapters/json-api';

const { String: { pluralize, underscore } } = Ember;

export default JSONAPIAdapter.extend({
  pathForType(type) {
    return pluralize(underscore(type));
  }
});
```
**Content Security Policy (CSP)**

```
ember install ember-cli-content-security-policy
```

```
// config/environment.js
//...
locationType: 'auto',
contentSecurityPolicy: {
  'style-src': "'self' 'unsafe-inline'",
  'script-src': "'self' 'unsafe-eval' 127.0.0.1:35729",
  'connect-src': "'self' http://localhost:3000 http://127.0.0.1:3000",
},
EmberENV: {
/...

```

### Create an Admin page

We would like to list out from the database the persisted email
addresses. Let’s create a new route and page what we can reach with the
following url: `http://localhost:4200/admin/invitations`:

```
ember g route admin/invitations
```

Add this new page to the `navbar.hbs` with a dropdown.

```
<!-- app/templates/navbar.hbs -->
<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#main-navbar">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      {{#link-to 'index' class="navbar-brand"}}Library App{{/link-to}}
    </div>

    <div class="collapse navbar-collapse" id="main-navbar">
      <ul class="nav navbar-nav">
        {{#link-to 'index' tagName="li"}}<a href="">Home</a>{{/link-to}}
        {{#link-to 'about' tagName="li"}}<a href="">About</a>{{/link-to}}
        {{#link-to 'contact' tagName="li"}}<a href="">Contact</a>{{/link-to}}
      </ul>

      <ul class="nav navbar-nav navbar-right">
        <li class="dropdown">
          <a class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Admin<span
              class="caret"></span></a>
          <ul class="dropdown-menu">
            {{#link-to 'admin.invitations' tagName="li"}}<a href="">Invitations</a>{{/link-to}}
          </ul>
        </li>
      </ul>
    </div>
  </div>
</nav>
```
Add a table to `app/templates/admin/invitations.hbs`:

```
<!-- app/templates/admin/invitations.hbs -->
<h1>Invitations</h1>

<table class="table table-bordered table-striped">
  <thead>
    <tr>
      <th>ID</th>
      <th>E-mail</th>
    </tr>
  </thead>
  <tbody>
    {{#each model as |invitation|}}
      <tr>
        <th>{{invitation.id}}</th>
        <td>{{invitation.email}}</td>
      </tr>
    {{/each}}
  </tbody>
</table>
```

We use the `{{#each}}{{/each}}` handlebar block helper to generate a
list. The `model` variable will contain an array of invitations which we
will retrieve from the server. Ember.js automatically populates
responses from the server, however we have not implemented this step
yet.

Let’s retrieve our data from the server using a Route Handler and Ember
Data.

[The official guide about Route’s Model][14]

Add the following code to your `app/routes/admin/invitations.js` file:

```
// app/routes/admin/invitations.js
import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.findAll('invitation');
  }
});

```

**Check out and edit route**

```
// app/router.js
import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('about');
  this.route('contact');

  this.route('admin', function() {
    this.route('invitations');
  });
});

export default Router;
```

*Launch your app and check your table in Admin.*

**Run Server's**

As you will probably know, this is the URL of your running Rails or
Phoenix dev server. ;)

```
# start up backend
bundle exec rails s -b api.dev.local
# start up frontend
ember server --proxy "http://api.dev.local:3000"
```

### CRUD interface for libraries

We create our new route. At the moment we’ll do it without Ember CLI;
just manually add the following lines to our `router.js`:

```
// app/router.js
import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('about');
  this.route('contact');

  this.route('admin', function() {
    this.route('invitations');
  });

  this.route('libraries', function() {
    this.route('new');
    this.route('edit', { path: '/:library_id/edit' });
  });
});

export default Router;
```

Now we create 3 new templates. Our main `libraries.hbs`, a
`libraries/index.hbs` for displaying the list, and a
`libraries/new.hbs` for a library creation form.

```
ember g template libraries
ember g template libraries/index
ember g template libraries/new
ember g template libraries/form
ember g template libraries/edit
```

Update your `navbar.hbs` main navigation section as follows:

```
<!-- app/templates/navbar.hbs -->
<ul class="nav navbar-nav">
  {{#link-to 'index' tagName="li"}}<a href="">Home</a>{{/link-to}}
  {{#link-to 'libraries' tagName="li"}}<a href="">Libraries</a>{{/link-to}}
  {{#link-to 'about' tagName="li"}}<a href="">About</a>{{/link-to}}
  {{#link-to 'contact' tagName="li"}}<a href="">Contact</a>{{/link-to}}
</ul>
```

Add a submenu to `libraries.hbs`:

```
<!-- app/templates/libraries.hbs -->
<h1>Libraries</h1>

<div class="well">
  <ul class="nav nav-pills">
    {{#link-to 'libraries.index' tagName="li"}}<a href="">List all</a>{{/link-to}}
    {{#link-to 'libraries.new' tagName="li"}}<a href="">Add new</a>{{/link-to}}
  </ul>
</div>

{{outlet}}
```

Check app; you should see a new menu item, and a submenu with two
items under `/libraries`.

The other two templates should have the following content.

```
<!-- app/templates/libraries/index.hbs -->
<h2>List</h2>
<div class="row">
  {{#each model as |library|}}
    <div class="col-md-4">
      {{#library-item item=library}}
        {{#link-to 'libraries.edit' library.id class='btn btn-success btn-xs'}}Edit{{/link-to}}
        <button class="btn btn-danger btn-xs" {{action 'deleteLibrary' library}}>Delete</button>
      {{/library-item}}
    </div>
  {{/each}}
</div>
```

We generate a list from our model which will be retrieved in the route.
We are using `panel` style from bootstrap here.

```
<!-- app/templates/libraries/new.hbs -->
<h2>Add a new local Library</h2>

<div class="row">
  <div class="col-md-6">
    {{library-item-form item=model buttonLabel='Add to library list' action='saveLibrary'}}
  </div>
  <div class="col-md-4">
    {{#library-item item=model}}
      <br/>
    {{/library-item}}
  </div>
</div>
```
We use `model` as our value store. You will soon see that our model will
be created in the route. The action attached to the submit button will
call a `saveLibrary` function that we’ll pass the `model` parameter to.

Edit `form.hbs` and `edit.hbs`:

```
<!-- app/templates/libraries/form.hbs -->
<h2>{{title}}</h2>

<div class="row">
  <div class="col-md-6">
    {{library-item-form item=model buttonLabel=buttonLabel action='saveLibrary'}}
  </div>
  <div class="col-md-4">
    {{#library-item item=model}}
      <br/>
    {{/library-item}}
  </div>
</div>
```

```
<!-- app/templates/libraries/edit.hbs -->
<h2>Edit Library</h2>

<div class="row">
  <div class="col-md-6">
    {{library-item-form item=model buttonLabel='Save changes' action='saveLibrary'}}
  </div>
  <div class="col-md-4">
    {{#library-item item=model}}
      <br/>
    {{/library-item}}
  </div>
</div>
```

In `app/routes`  folder create `libraries` folder and add two js files:
`index.js`, `new.js`, 'edit.js':

```
// app/routes/libraries/index.js
import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.findAll('library');
  },

  actions: {
    deleteLibrary(library) {
      let confirmation = confirm('Are you sure?');

      if (confirmation) {
        library.destroyRecord();
      }
    }
  }
});
```
In the route above, we retrieve all the library records from the server.

```
// app/routes/libraries/new.js
import Ember from 'ember';

export default Ember.Route.extend({
  model: function () {
    return this.store.createRecord('library');
  },

  setupController: function (controller, model) {
    this._super(controller, model);

    controller.set('title', 'Create a new library');
    controller.set('buttonLabel', 'Create');
  },

  renderTemplate() {
    this.render('libraries/form');
  },

  actions: {
    saveLibrary(newLibrary) {
      newLibrary.save().then(() => this.transitionTo('libraries'));
    },

    willTransition() {
      let model = this.controller.get('model');

      if (model.get('isNew')) {
        model.destroyRecord();
      }
    }
  }
});

```

```
// app/routes/libraries/edit.js
import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return this.store.findRecord('library', params.library_id);
  },

  actions: {
    saveLibrary(newLibrary) {
      newLibrary.save().then(() => this.transitionTo('libraries'));
    },

    willTransition(transition) {
      let model = this.controller.get('model');

      if (model.get('hasDirtyAttributes')) {
        let confirmation = confirm("Your changes haven't saved yet. Would you like to leave this form?");

        if (confirmation) {
          model.rollbackAttributes();
        } else {
          transition.abort();
        }
      }
    }
  }
});
```

In the above route’s model method, we create a new record and that will
be the `model`. It automatically appears in the controller and in the
template. In the `saveLibrary` action we accept a parameter and we save
that model, and then we send the application back to the Libraries home
page with `transitionTo`.

There is a built-in Ember.js action (event) called `willTransition` that
is called when you leave a page (route). In our case, we use this action
to reset the model if we haven’t saved it in the database yet.

As you can see, we can access the controller from the route handler
using `this.controller`, however we don’t have a real controller file
for this route (`/libraries/new.js`). Ember.js’s dynamic code generation
feature automatically creates controllers and route handlers for each
route. They exists in memory. In this example, the `model` property
exists in this “virtual” controller and in our template, so we can still
“destroy” it.

Open the browser and please check out these automatically generated
routes and controllers in Ember Inspector, under the “Routes” section.
You will see how many different elements are dynamically created.

What is that nice one liner in our `saveLibrary()` method?

```
newLibrary.save().then(() => this.transitionTo('libraries'));
```

In ES2015, with the `=> syntax`,  if we only have one line of code (like
`return` + something) we can use a cleaner structure, without curly
braces and `return`.

In a previous version we had the following code in `willTransition()`.

```
willTransition() {
  let model = this.controller.get('model');

  if (model.get('isNew')) {
    model.destroyRecord();
  }
}
```

We have a simpler solution. Using `rollbackAttributes()` is cleaner.
It destroys the record automatically if it is new.

### Cleaning up our templates with components

First of all, please read more about [Components][15] in the Ember.js
Guide:

Let’s create two components. One for the library panel, and one for
forms.

```
ember g component library-item
ember g component library-item-form
```

We can insert the following code into our `library-item` template:

```
<!-- app/templates/components/library-item.hbs -->
<div class="panel panel-default library-item">
  <div class="panel-heading">
    <h3 class="panel-title">{{item.name}}</h3>
  </div>
  <div class="panel-body">
    <p>Address: {{item.address}}</p>
    <p>Phone: {{item.phone}}</p>
  </div>
  <div class="panel-footer text-right">
    {{yield}}
  </div>
</div>
```
Let’s add html to our `library-item-form` component as well.

```
<!-- app/templates/components/library-item-form.hbs -->
<div class="form-horizontal">
  <div class="form-group has-feedback {{if item.isValid 'has-success'}}">
    <label class="col-sm-2 control-label">Name*</label>
    <div class="col-sm-10">
      {{input type="text" value=item.name class="form-control" placeholder="The name of the Library"}}
      {{#if item.isValid}}<span class="glyphicon glyphicon-ok form-control-feedback"></span>{{/if}}
    </div>
  </div>
  <div class="form-group">
    <label class="col-sm-2 control-label">Address</label>
    <div class="col-sm-10">
      {{input type="text" value=item.address class="form-control" placeholder="The address of the Library"}}
    </div>
  </div>
  <div class="form-group">
    <label class="col-sm-2 control-label">Phone</label>
    <div class="col-sm-10">
      {{input type="text" value=item.phone class="form-control" placeholder="The phone number of the Library"}}
    </div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-2 col-sm-10">
      <button type="submit" class="btn btn-default" {{action 'buttonClicked' item}} disabled={{unless item.isValid true}}>{{buttonLabel}}</button>
    </div>
  </div>
</div>
```
Add the `buttonClicked` action to `library-item-form.js`:

```
// app/components/library-item-form.js
import Ember from 'ember';

export default Ember.Component.extend({
  buttonLabel: 'Save',

  actions: {
    buttonClicked(param) {
      this.sendAction('action', param);
    }
  }
});
```

### CRUD interface for Authors and Books, managing model relationship

We are going to create two new pages: Authors and Books, where we list
our data and manage them. We implement create, edit and delete
functionality, search and pagination also. You can learn here, how could
you manage relations between models.

Let’s create our two new pages.

[1]: http://www.ember-cli.com
[2]: http://localhost:4200
[3]: http://www.emberaddons.com
[4]: http://www.emberobserver.com
[5]: http://guides.emberjs.com/v2.15.0/templates/conditionals/
[6]: http://getbootstrap.com/components/#jumbotron
[7]: http://getbootstrap.com/css/#forms
[8]: http://guides.emberjs.com/v2.15.0/controllers/
[9]: http://guides.emberjs.com/v2.15.0/object-model/computed-properties/
[10]: http://guides.emberjs.com/v2.15.0/object-model/observers/
[11]: http://emberjs.com/api/classes/Ember.computed.html
[12]: http://guides.emberjs.com/v2.15.0/models/
[13]: https://emberjs.com/api/ember-data/2.14.10/classes/DS.Adapter
[14]: http://guides.emberjs.com/v2.15.0/routing/specifying-a-routes-model/
[15]: https://guides.emberjs.com/v2.15.0/components/defining-a-component/
