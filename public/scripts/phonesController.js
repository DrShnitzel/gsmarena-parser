angular
  .module('ngPhones')
  .controller('phonesController', function($scope, brandsFactory, phonesFactory, phoneFactory, searchFactory) {
    $scope.brands;
    $scope.phones;
    $scope.phoneSpecs;

    brandsFactory.getBrands().success(function(data) {
			$scope.brands = data;
		}).error(function(error) {
			console.log(error);
		});

    $scope.selectedBrand;
    $scope.selectedPhone;
    $scope.phoneSelectVisible = false;
    $scope.searchText;
    $scope.searchResult;

    $scope.findPhones = function(url) {
      $scope.phoneSelectVisible = true;
      phonesFactory.getPhones(url).success(function(data) {
  			$scope.phones = data;
  		}).error(function(error) {
  			console.log(error);
  		});
    }

    $scope.phoneInfo = function(url) {
      phoneFactory.getPhone(url).success(function(data) {
  			$scope.phoneSpecs = data;
  		}).error(function(error) {
  			console.log(error);
  		});
    }

    $scope.searchPhone = function(text) {
      searchFactory.getResult(text).success(function(data) {
  			$scope.searchResult = data;
  		}).error(function(error) {
  			console.log(error);
  		});
    }
  });
