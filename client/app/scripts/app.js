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
    'ngTouch',
    'angularMoment'
  ]);

app.config(function ($routeProvider) {
  $routeProvider.when('/', {
    templateUrl: 'views/ratings.html',
    controller: 'RatingsCtrl'
  });
  $routeProvider.otherwise({redirectTo: '/'});
});

app.factory('Rating', ['$resource', function ($resource) {
  return $resource('/api/ratings/:id.json', null, {
    'update': {method: 'PUT'}
  });
}]);

app.directive('starRating', function() {
  return {
    restrict: 'A',
    template: '<ul class="star-rating">' +
              ' <li ng-repeat="star in stars" ng-class="star">' +
              '  <span class="star"></span>' +
              ' </li>' +
              '</ul>',
    scope: {
      ratingValue: '=',
      max: '='
    },
    link: function(scope) {
      var update_rating = function() {
        scope.stars = [];
        for (var i=0; i<scope.max; i++) {
          scope.stars.push({
            filled: i < scope.ratingValue,
            half: i - 0.5 === scope.ratingValue
          });
        }
      };
      scope.$watch('ratingValue',
        function(old_value, new_value) {
          if (new_value) {
            update_rating();
          }
        }
      );
    }
  };
});

app.directive('starRater', function() {
  return {
    restrict: 'A',
    template: '<ul class="star-rating mutable">' +
              ' <li ng-repeat="star in stars" ng-class="star" ng-click="toggle($index)">' +
              '  <span class="star"></span>' +
              ' </li>' +
              '</ul>',
    scope: {
      ratingValue: '=',
      max: '=',
      onRatingSelected: '&'
    },
    link: function(scope) {
      var update_rating = function() {
        scope.stars = [];
        for (var i=0; i<scope.max; i++) {
          scope.stars.push({
            filled: i < scope.ratingValue,
            half: i - 0.5 === scope.ratingValue
          });
        }
      };
      update_rating();
      scope.toggle = function(index) {
        scope.ratingValue = index + 1;
        scope.onRatingSelected({rating: index + 1});
      };
      scope.$watch('ratingValue',
        function(new_value, old_value) {
          if (new_value !== old_value) {
            update_rating();
          }
        }
      );
    }
  };
});
