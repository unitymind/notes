var notesControllers = angular.module('notesControllers', ['restangular']);

notesControllers.controller('NoteListCtrl', ['$scope', '$animate', 'Restangular', function($scope, $animate, Restangular) {
    $scope.isEmpty = true;
    $scope.isRefreshing = false;

    $scope.refresh = function() {
        $scope.isRefreshing = true;
        $animate.enabled(false);
        $scope.notes = [];

        Restangular.all('notes').getList().then(function(items) {
            $scope.notes = items;
            if (_.size(items) > 0) {
                $scope.isEmpty = false;
            }
            $scope.isRefreshing = false;
            $animate.enabled(true);
        });
    };

    $scope.delete = function(note) {
        note.remove().then(function() {
            $scope.notes = _.without($scope.notes, note);
            if (_.size($scope.notes) === 0) {
                $scope.isEmpty = true;
            }
        });
    };

    $scope.refresh();
}]).controller('NoteFormCtrl', ['$scope', '$location', 'Restangular', function($scope, $location, Restangular) {
    $scope.save = function() {
        Restangular.all('notes').post({note: $scope.note}).then(function(note) {
            console.log(note.id);
            $location.path("/#/index");
        });
    };
}]);