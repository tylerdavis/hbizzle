angular.module('filters.start_from', []);
angular.module('filters.start_from').filter('startFrom', [function () {
  return function(input, start) {
    start = +start; //parse to int
    return input.slice(start);
  };
}]);