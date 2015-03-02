# evaluatjon.com

## What is this?

This started as a joke between friends and my boyfriend Jon. The name
evaluatjon is a play on Jon's name and "evaluation." I bought the domain name
and then I couldn't just sit on it, so this app was born. It lets you rate
Jon's different traits and leave a little comment with your rating. Jon can
then log in and respond to ratings, as well as delete both ratings and his own
responses.

Someone might find use in this as a guestbook, a survey tool, or a fun way to
elicit feedback about yourself or anything really. It's built as a Ruby on
Rails JSON API back end and an AngularJS front end. I used Bower, Yeoman, and
Grunt to develop it.

![screenshot](https://raw.githubusercontent.com/moneypenny/evaluatjon.com/master/screenshot.png)

## How to Develop

You need [Ruby](https://www.ruby-lang.org/en/installation/) (I recommend [RubyInstaller](http://rubyinstaller.org/downloads/) and its DevKit for Windows), [RubyGems](https://rubygems.org/pages/download), [Bundler](http://bundler.io/), [PostgreSQL](http://www.postgresql.org/download/), and [node.js and npm](http://nodejs.org/).

1. `bundle`
1. `createuser -P -s -e evaluatjon`
1. `rake db:create db:migrate db:seed`
1. `cd client`
1. `npm install`
1. `npm install -g bower`
1. `bower install`
1. `npm install -g grunt-cli`
1. `grunt serve` to watch for front end file changes as well as start the Rails server.

## How to Test

1. `RAILS_ENV=test rake db:create db:migrate`
1. `RAILS_ENV=test rake spec:controllers`
1. `RAILS_ENV=test rake spec:models`

### Feature Tests

These use [Capybara Webkit](https://github.com/thoughtbot/capybara-webkit). You will need [Qt](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit).

1. `grunt heroku:production` to update the contents of `public/`.
1. `RAILS_ENV=test rake spec:features`

## How to Deploy to Heroku

1. `git remote add heroku git@heroku.com:yourherokuapp.git`
1. `heroku config:set NODE_ENV=production`
1. `heroku config:add BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git`
1. `git push heroku master`
1. `heroku run rake db:migrate`
1. `heroku run rake db:seed`
1. `heroku ps:scale web=1`
1. Optionally run `heroku run rails c` to open a Rails console and manually create a user, ideally Jon. This user will be able to create replies, delete replies, and delete ratings. Their replies always show up tagged as Jon.

## Thanks

Thanks to [How to Wire Up Ruby on Rails and AngularJS as a Single-Page Application](http://www.angularonrails.com/ruby-on-rails-angularjs-single-page-application/).
