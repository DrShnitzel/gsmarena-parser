angular
  .module('ngPhones')
  .factory('phoneFactory', function($http) {
    function getPhone(phone_url) {
      return $http.get('/api/phone?phone_url=' + phone_url);
    }
    return {
      getPhone: getPhone
    }
  });
