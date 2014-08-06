'use strict';

/**
 * @ngdoc overview
 * @name evaluatjonApp
 * @description
 * # evaluatjonApp
 *
 * Main module of the application.
 */
var app = angular.module('evaluatjonApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch'
  ]);

app.config(function ($routeProvider) {
  $routeProvider.when('/', {
    templateUrl: 'views/main.html',
    controller: 'MainCtrl'
  });
  $routeProvider.when('/ratings', {
    templateUrl: 'views/ratings.html',
    controller: 'RatingsCtrl'
  });
  $routeProvider.otherwise({redirectTo: '/'});
});

app.factory('Rating', ['$resource', function ($resource) {
  return $resource('/api/ratings/:id.json', null, {
    'update': { method:'PUT' }
  });
}]);
