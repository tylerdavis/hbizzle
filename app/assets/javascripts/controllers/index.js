angular.module('controllers.index', ['filters.start_from', 'ui.bootstrap', 'ui.bootstrap.tpls']);
angular.module('controllers.index').controller('IndexCtrl', ['$http', '$scope', '$location', function ($http, $scope, $location) {
  
  $scope.currentPage = 1;
  $scope.movies = window.movies;
  $scope.pageSize = 6;
  $scope.predicate = '-meta_score';
  $scope.showPagesNum = 8;

  $scope.goToCurrentPage = function () {
    $scope.currentPage = 1;
    $scope.predicate = '-meta_score';
    $scope.reverse = false;
  };

  $scope.play = function (movie, event) {
    $http({
      data : { hbo_id : movie.hbo_id },
      method : 'POST',
      url : '/play'
    });
  };

  $scope.sortDirection = function () {
    return ($scope.reverse) ? 'ascending' : 'descending';
  };

  $scope.updatePredicate = function (predicate) {
    if ($scope.predicate === predicate) {
      $scope.reverse = !$scope.reverse
    };
      $scope.currentPage = 1;
      $scope.predicate = predicate;
  };
}]);