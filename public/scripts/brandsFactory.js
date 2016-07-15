angular
  .module('ngPhones')
  .factory('brandsFactory', function($http) {
    function getBrands() {
      return $http.get('/api/brands');
    }
    return {
      getBrands: getBrands
    }
  });
