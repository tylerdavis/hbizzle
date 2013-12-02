angular.module('controllers.index', ['factories.movie']);
angular.module('controllers.index').controller('IndexCtrl', ['Movie', '$scope', function (Movie, $scope) {
  $scope.movies = Movie.list();
  $scope.predicate = '-imdb_rating';
}]);