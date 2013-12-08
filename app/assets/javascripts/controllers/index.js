angular.module('controllers.index', ['filters.start_from', 'ui.bootstrap', 'ui.bootstrap.tpls']);
angular.module('controllers.index').controller('IndexCtrl', ['$http', '$scope', '$location', function ($http, $scope, $location) {
  
  $scope.movies = window.movies;
  $scope.predicate = '-meta_score';
  $scope.currentPage = 1;
  $scope.pageSize = 6;
  $scope.showPagesNum = 8;

  $scope.goToCurrentPage = function () {
    $scope.currentPage = 1;
    $scope.predicate = '-meta_score';
    $scope.reverse = false;
  };

  $scope.play = function (movie, event) {
    var data = { hbo_id : movie.hbo_id };
    $http({
      url : '/play',
      method : 'POST',
      data : data
    });
  };

  $scope.sortDirection = function () {
    return ($scope.reverse) ? 'ascending' : 'descending';
  };

  $scope.updatePredicate = function (predicate) {
    if ($scope.predicate === predicate) {
      $scope.reverse = !$scope.reverse
    };
      $scope.predicate = predicate;
      $scope.currentPage = 1;
  };
}]);