evaluatjon.com
==============

What am I doing.

## How to Develop

For API:

1. `bundle`
1. `createuser -P -s -e evaluatjon`
1. `rake db:create db:migrate db:seed`
1. `rails s`

For front end:

1. `cd client`
1. `npm install`
1. `bower install`
1. `grunt serve`

## How to Test

1. `RAILS_ENV=test rake db:create db:migrate`
1. `RAILS_ENV=test rspec`

## Thanks

Thanks to [How to Wire Up Ruby on Rails and AngularJS as a Single-Page Application](http://www.angularonrails.com/ruby-on-rails-angularjs-single-page-application/).
