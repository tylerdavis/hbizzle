angular.module('factories.movie', ['ngResource']);
angular.module('factories.movie').factory('Movie', ['$resource', function ($resource) {
  return $resource('/movies/:id', { id : '@_id' }, {
    list : { method : 'GET', isArray : true }
  });
}]);