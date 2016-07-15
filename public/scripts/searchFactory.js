angular
  .module('ngPhones')
  .factory('searchFactory', function($http) {
    function getResult(text) {
      return $http.get('/api/search?text=' + text);
    }
    return {
      getResult: getResult
    }
  });
