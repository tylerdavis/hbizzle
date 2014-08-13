angular.module('controllers.index', ['filters.start_from', 'ngCookies', 'ui.bootstrap', 'ui.bootstrap.tpls', 'factories.youtube']);
angular.module('controllers.index').controller('IndexCtrl', ['$cookies', '$http', '$scope', 'Youtube',
  function ($cookies, $http, $scope, Youtube) {

    $scope.currentPage = 1;
    $scope.movies = window.movies;
    $scope.pageSize = 6;
    $scope.predicate = '-meta_score';
    $scope.showPagesNum = 8;
    $scope.trailerIframe = '';
    var trailerPlaying = false;
    var $trailerContainer = $('#trailer-container');

    var cookies = ($cookies.hbizzle) ? JSON.parse($cookies.hbizzle) : [];

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

    $scope.playTrailer = function (movie, event) {
      if (trailerPlaying) return;
      var height, width;
      var windowHeight = window.innerHeight;
      var windowWidth = window.innerWidth;
      if (windowWidth > windowHeight) {
        height = windowHeight - 140;
        width = height * 1.2;
      } else {
        width = windowWidth - 40;
        height = width * 0.8;
      }
      var iframe = $('<iframe>').attr('type', 'text/html').attr('src', movie.youtube).attr('frameborder', 0)
        .attr('height', height + 'px').attr('width', width + 'px');
      $trailerContainer.prepend(iframe).fadeIn();
      $trailerContainer.find('h2').fadeIn();
      trailerPlaying = true;
    };

    $scope.stopTrailer = function () {
      if (!trailerPlaying) return;
      $trailerContainer.find('h2').hide();
      $trailerContainer.fadeOut().find('iframe').remove();
      trailerPlaying = false;
    };

    $scope.sortDirection = function () {
      return ($scope.reverse) ? 'ascending' : 'descending';
    };

    $scope.updatePredicate = function (predicate) {
      if ($scope.predicate === predicate) {
        $scope.reverse = !$scope.reverse
      }
      $scope.currentPage = 1;
      $scope.predicate = predicate;
    };
}]);