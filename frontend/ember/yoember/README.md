## Building a complex web application with Ember.js 2.14

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
### Create the application

```
ember new yoember
ember server

ember generate template application
echo '<h1>Welcome to Ember</h1>' > app/templates/application.hbs
```

### Turn on a few debugging options

```
# config/environment.js
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
find various packages, add-ons on these websites: [emberaddons][1],
[emberobserver][2].

```
ember install ember-cli-sass
ember install ember-cli-bootstrap-sassy

mv app/styles/app.css app/styles/app.scss

echo '@import "bootstrap";' > app/styles/app.scss
```

### Create a navigation partial

[1]: http://www.emberaddons.com
[2]: http://www.emberobserver.com
