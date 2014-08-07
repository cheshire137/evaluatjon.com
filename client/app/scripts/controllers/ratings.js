'use strict';

/**
 * @ngdoc function
 * @name evaluatjonApp.controller:RatingsCtrl
 * @description
 * # RatingsCtrl
 * Controller of the evaluatjonApp
 */
angular.module('evaluatjonApp')
  .controller('RatingsCtrl', ['$scope', 'Rating', function ($scope, Rating) {
    $scope.ratings = Rating.query();
    $scope.new_rating = {stars: 0, error_messages: []};

    $scope.set_new_rating_stars = function(stars) {
      $scope.new_rating.stars = stars;
    };

    $scope.create_rating = function() {
      var on_success = function (rating) {
        $scope.ratings.unshift(rating);
      };
      var on_error = function (response) {
        $scope.new_rating.error_messages = response.data;
      };
      Rating.save({rating: $scope.new_rating}, on_success, on_error);
    };
  }]);
