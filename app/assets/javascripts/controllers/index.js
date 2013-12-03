angular.module('controllers.index', []);
angular.module('controllers.index').controller('IndexCtrl', ['$scope', function ($scope) {
  $scope.movies = window.movies;
  $scope.predicate = '-imdb_rating';
}]);