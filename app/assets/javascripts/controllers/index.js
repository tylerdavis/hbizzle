angular.module('controllers.index', ['filters.start_from', 'ui.bootstrap', 'ui.bootstrap.tpls']);
angular.module('controllers.index').controller('IndexCtrl', ['$http', '$scope', '$location', function ($http, $scope, $location) {
  
  $scope.movies = window.movies;
  $scope.predicate = '-meta_score';
  $scope.currentPage = 1;
  $scope.pageSize = 6;
  $scope.showPagesNum = 8;

  $scope.play = function (movie, event) {
    event.preventDefault();
    var data = { hbo_id : movie.hbo_id };
    $http.post('/play', data)
      .success(function () {
        window.open(movie.hbo_link);
      });
  };

  $scope.sortDirection = function () {
    return ($scope.reverse) ? 'ascending' : 'descending';
  }

  $scope.updatePredicate = function (predicate) {
    if ($scope.predicate === predicate) {
      $scope.reverse = !$scope.reverse
    };
      $scope.predicate = predicate;
      $scope.currentPage = 1;
  };
}]);