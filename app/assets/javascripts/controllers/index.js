angular.module('controllers.index', ['filters.start_from', 'ui.bootstrap', 'ui.bootstrap.tpls']);
angular.module('controllers.index').controller('IndexCtrl', ['$http', '$scope', '$location', function ($http, $scope, $location) {
  
  $scope.movies = window.movies;
  $scope.predicate = '-meta_score';
  $scope.currentPage = 1;
  $scope.pageSize = 10;
  $scope.showPagesNum = 8;

  $scope.sortDirection = function () {
    return ($scope.reverse) ? 'ascending' : 'descending';
  }

  $scope.play = function (movie, event) {
    event.preventDefault();
    var data = { hbo_id : movie.hbo_id };
    $http.post('/play', data)
      .success(function () {
        window.open(movie.hbo_link);
      });
  };

}]);