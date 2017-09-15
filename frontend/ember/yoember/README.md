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
// app/templates/application.hbs

<div class="container">
  {{partial 'navbar'}}
  {{outlet}}
</div>
```

```
ember generate template navbar

// app/templates/navbar.hbs
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
@import "bootstrap";

body {
  padding-top: 20px;
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
// app/templates/navbar.hbs

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


```
ember g model contact
```


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
[12]:
[13]:
[14]:
[15]:
[16]:
[17]:
[18]:
[19]:
[20]:
