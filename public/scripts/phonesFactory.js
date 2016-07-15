angular
  .module('ngPhones')
  .factory('phonesFactory', function($http) {
    function getPhones(brand_url) {
      return $http.get('/api/phones?brand_url=' + brand_url);
    }
    return {
      getPhones: getPhones
    }
  });
