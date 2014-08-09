'use strict';

$(function() {
  $('body').tooltip({selector: '[data-toggle="tooltip"]'});
});

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
    'angularMoment',
    'Devise'
  ]);

app.config(function(AuthProvider) {
  AuthProvider.loginPath('/api/users/sign_in');
  AuthProvider.loginMethod('POST');
  AuthProvider.logoutPath('/api/users/sign_out.json');
  AuthProvider.logoutMethod('DELETE');
});

app.config(function ($routeProvider) {
  $routeProvider.when('/', {
    templateUrl: 'views/ratings.html',
    controller: 'RatingsCtrl'
  });
  $routeProvider.otherwise({redirectTo: '/'});
});

app.factory('Rating', ['$resource', function ($resource) {
  return $resource('/api/ratings/:id.json',
                   {id: '@id'},
                   {'update': {method: 'PUT'}});
}]);

app.factory('Reply', ['$resource', function ($resource) {
  return $resource('/api/ratings/:rating_id/replies/:id.json',
                   {id: '@id', rating_id: '@rating_id'},
                   {'update': {method: 'PUT'}});
}]);

app.directive('starRating', function() {
  return {
    restrict: 'A',
    template: '<ul class="star-rating">' +
              ' <li ng-repeat="star in stars" class="star" ng-class="{filled: star.filled, half: star.half}">' +
              '  <span class="star"></span>' +
              ' </li>' +
              '</ul>',
    scope: {
      ratingValue: '=',
      max: '='
    },
    link: function(scope) {
      scope.stars = [];
      for (var i=0; i<scope.max; i++) {
        scope.stars.push({index: i, filled: false, half: false});
      }
      var update_rating = function() {
        for (var i=0; i<scope.max; i++) {
          scope.stars[i].filled = i < scope.ratingValue;
          scope.stars[i].half = i - 0.5 === scope.ratingValue;
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
              ' <li ng-repeat="star in stars" class="star" ng-class="{hover: star.hover, filled: star.filled, half: star.half, active: star.active}" ng-click="toggle($event, star)" ng-mousemove="on_move($event, star)" ng-mouseover="on_hover($event, star)" ng-mouseleave="off_hover()">' +
              '  <span class="star"></span>' +
              ' </li>' +
              '</ul>',
    scope: {
      ratingValue: '=',
      max: '=',
      onRatingSelected: '&'
    },
    link: function(scope, element) {
      scope.stars = [];
      for (var i=0; i<scope.max; i++) {
        scope.stars.push({index: i, active: false, hover: false, filled: false,
                          half: false});
      }
      var update_rating = function() {
        for (var i=0; i<scope.max; i++) {
          scope.stars[i].filled = i < scope.ratingValue;
          scope.stars[i].half = i - 0.5 === scope.ratingValue;
        }
      };
      update_rating();
      var set_half = function(event, star) {
        var mouse_x = event.offsetX;
        var offset_index = star.index + 1;
        var star_el = element.find(':nth-child(' + offset_index + ')');
        var star_width = star_el.width();
        var star_left = star_el.offset().left;
        var star_half_width = star_left + (star_width / 2.0);
        star.half = star_left + mouse_x < star_half_width;
      };
      scope.on_hover = function(event, star) {
        star.active = true;
        if (!star.filled) {
          set_half(event, star);
        }
        for (var i=0; i<=star.index; i++) {
          scope.stars[i].hover = true;
        }
        for (var j=star.index+1; j<scope.max; j++) {
          scope.stars[j].hover = false;
        }
      };
      scope.on_move = function(event, star) {
        if (!star.filled) {
          set_half(event, star);
        }
      };
      scope.off_hover = function() {
        for (var i=0; i<scope.max; i++) {
          scope.stars[i].active = false;
          scope.stars[i].hover = false;
          scope.stars[i].half = i - 0.5 === scope.ratingValue;
        }
      };
      scope.toggle = function(event, star) {
        set_half(event, star);
        if (star.filled) {
          scope.ratingValue = 0;
        } else {
          var increment = star.half ? -0.5 : 1;
          scope.ratingValue = star.index + increment;
        }
        update_rating();
        scope.onRatingSelected({rating: scope.ratingValue});
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
