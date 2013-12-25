angular.module('controllers.index', ['filters.start_from', 'ngCookies', 'ui.bootstrap', 'ui.bootstrap.tpls']);
angular.module('controllers.index').controller('IndexCtrl', ['$cookies', '$http', '$scope', '$location', 
  function ($cookies, $http, $scope, $location) {

    $scope.currentPage = 1;
    $scope.movies = window.movies;
    $scope.pageSize = 6;
    $scope.predicate = '-meta_score';
    $scope.showPagesNum = 8;

    var cookies = (!!$cookies.hbizzle) ? JSON.parse($cookies.hbizzle) : [];

    $scope.color = function (value) {
      if (value < 20 && value > 100) return false;
      
      var r = Math.floor(255 * (100 - value) / 100),
          g = Math.floor(255 * value / 100),
          b = 0;
      return 'rgba(' + [r,g,b].join(',') + ',0.7)';
    };

    $scope.goToCurrentPage = function () {
      $scope.currentPage = 1;
      $scope.predicate = '-meta_score';
      $scope.reverse = false;
    };

    $scope.play = function (movie, event) {
      cookies.push(movie.hbo_id);
      $cookies.hbizzle = JSON.stringify(cookies);
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