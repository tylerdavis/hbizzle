angular.module('controllers.index', []);
angular.module('controllers.index').controller('IndexCtrl', ['$http', '$scope', '$location', function ($http, $scope, $location) {
  
  $scope.movies = window.movies;
  $scope.predicate = '-meta_score';

  $scope.play = function (movie, event) {
    event.preventDefault();
    var data = { hbo_id : movie.hbo_id };
    $http.post('/play', data)
      .success(function () {
        window.open(movie.hbo_link);
      });
  };

}]);