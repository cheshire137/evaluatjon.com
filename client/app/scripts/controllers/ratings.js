'use strict';

/**
 * @ngdoc function
 * @name evaluatjonApp.controller:RatingsCtrl
 * @description
 * # RatingsCtrl
 * Controller of the evaluatjonApp
 */
angular.module('evaluatjonApp')
  .controller('RatingsCtrl', ['$scope', 'Rating', 'Reply', 'Auth', function ($scope, Rating, Reply, Auth) {
    $scope.ratings = Rating.query();
    $scope.new_rating = {stars: 0, error_messages: []};
    $scope.auth_status = {logged_in: Auth.isAuthenticated(),
                          user: {}};
    $scope.credentials = {email: '', password: ''};
    $scope.toggle = {show_reply_form: {}};
    $scope.new_reply = {message: '', error_messages: []};

    $scope.login = function() {
      Auth.login($scope.credentials);
    };

    $scope.$on('devise:login', function(event, current_user) {
      $scope.auth_status.logged_in = true;
      $scope.auth_status.user = current_user;
      console.log('logged in as', current_user);
    });

    $scope.set_new_rating_stars = function(stars) {
      $scope.new_rating.stars = stars;
    };

    $scope.create_rating = function() {
      var on_success = function (rating) {
        $scope.ratings.unshift(rating);
        $scope.new_rating.stars = 0;
        $scope.new_rating.error_messages.length = 0;
        $scope.new_rating.dimension = '';
        $scope.new_rating.comment = '';
        $scope.new_rating.rater = '';
      };
      var on_error = function (response) {
        $scope.new_rating.error_messages = response.data;
      };
      Rating.save({rating: $scope.new_rating}, on_success, on_error);
    };

    $scope.create_reply = function(rating) {
      console.log('create_reply', rating);
      var rating_id = rating.id;
      for (var other_rating_id in $scope.toggle.show_reply_form) {
        if (other_rating_id !== rating_id) {
          $scope.toggle.show_reply_form[other_rating_id] = false;
        }
      }
      var on_success = function (reply) {
        console.log('made reply', reply);
        rating.replies.unshift(reply);
        $scope.new_reply.message = '';
        $scope.new_reply.error_messages.length = 0;
      };
      var on_error = function (response) {
        $scope.new_reply.error_messages = response.data;
      };
      Auth.currentUser().then(function(user) {
        console.log('replying as user', user);
        Reply.save({rating_id: rating_id, reply: $scope.new_reply,
                    email: user.email, token: user.auth_token}, on_success,
                   on_error);
      });
    };
  }]);
