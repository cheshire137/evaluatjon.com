'use strict';

/**
 * @ngdoc function
 * @name evaluatjonApp.controller:RatingsCtrl
 * @description
 * # RatingsCtrl
 * Controller of the evaluatjonApp
 */
angular.module('evaluatjonApp')
  .controller('RatingsCtrl', ['$scope', '$window', 'Rating', 'Reply', 'Auth', function ($scope, $window, Rating, Reply, Auth) {
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

    $scope.delete_rating = function(rating) {
      var should_delete =
          $window.confirm('Are you sure you want to delete this rating?');
      if (!should_delete) {
        return;
      }
      var rating_id = rating.id;
      var on_success = function() {
        for (var i=0; i<$scope.ratings.length; i++) {
          if ($scope.ratings[i].id === rating_id) {
            $scope.ratings.splice(i, 1);
          }
        }
      };
      var on_error = function(response) {
        console.error('failed to delete rating', rating, response);
      };
      Auth.currentUser().then(function(user) {
        Rating.delete({email: user.email, token: user.auth_token,
                       id: rating_id}, on_success, on_error);
      });
    };

    $scope.create_reply = function(rating) {
      var rating_id = rating.id;
      for (var other_rating_id in $scope.toggle.show_reply_form) {
        if (other_rating_id !== rating_id) {
          $scope.toggle.show_reply_form[other_rating_id] = false;
        }
      }
      var on_success = function (reply) {
        rating.replies.unshift(reply);
        $scope.new_reply.message = '';
        $scope.new_reply.error_messages.length = 0;
      };
      var on_error = function (response) {
        $scope.new_reply.error_messages = response.data;
      };
      Auth.currentUser().then(function(user) {
        Reply.save({rating_id: rating_id, reply: $scope.new_reply,
                    email: user.email, token: user.auth_token}, on_success,
                   on_error);
      });
    };

    $scope.delete_reply = function(rating, reply) {
      var should_delete =
          $window.confirm('Are you sure you want to delete this reply?');
      if (!should_delete) {
        return;
      }
      var rating_id = rating.id;
      var reply_id = reply.id;
      var on_success = function() {
        for (var i=0; i<rating.replies.length; i++) {
          if (rating.replies[i].id === reply_id) {
            rating.replies.splice(i, 1);
          }
        }
      };
      var on_error = function(response) {
        console.error('failed to delete reply', reply, response);
      };
      Auth.currentUser().then(function(user) {
        Reply.delete({rating_id: rating_id, email: user.email,
                      token: user.auth_token, id: reply_id}, on_success,
                      on_error);
      });
    };
  }]);
