evaluatjon.com
==============

What am I doing.

## How to Develop

For API:

1. `bundle`
1. `createuser -P -s -e evaluatjon`
1. `rake db:create db:migrate db:seed`
1. `cd client`
1. `npm install`
1. `bower install`
1. `npm install -g grunt-cli`
1. `grunt serve` to watch for front end file changes as well as start the Rails server.

## How to Test

1. `RAILS_ENV=test rake db:create db:migrate`
1. `RAILS_ENV=test rspec`

## How to Deploy to Heroku

1. `git remote add heroku git@heroku.com:yourherokuapp.git`
1. `heroku config:set NODE_ENV=production`
1. `heroku config:add BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git`
1. `git push heroku master`
1. `heroku run rake db:migrate`
1. `heroku run rake db:seed`

## Thanks

Thanks to [How to Wire Up Ruby on Rails and AngularJS as a Single-Page Application](http://www.angularonrails.com/ruby-on-rails-angularjs-single-page-application/).
