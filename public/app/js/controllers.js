var notesControllers = angular.module('notesControllers', ['restangular']);

notesControllers.controller('NoteListCtrl', ['$scope', '$animate', 'Restangular', 'flash', function($scope, $animate, Restangular, flash) {
    $scope.isEmpty = true;
    $scope.isRefreshing = false;
    $scope.orderField = 'created_at';

    $scope.toggleOrder = function() {
        $scope.orderField = ($scope.orderField === 'created_at') ? '-created_at' : 'created_at';
    }

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
            flash.success = 'Note deleted';
        });
    };

    $scope.refresh();
}]).controller('NoteFormCtrl', ['$scope', '$location', 'Restangular', 'flash', '$routeParams',
        function($scope, $location, Restangular, flash, $routeParams) {
            if ($routeParams.noteId) {
                $scope.pageHeader = 'Edit your note';
                Restangular.one("notes", $routeParams.noteId).get().then(function(item){
                    $scope.note = item
                });
            } else {
                $scope.note = {}
                $scope.pageHeader = 'Create new note';
            }
            $scope.save = function() {
                if ($routeParams.noteId) {
                    $scope.note.save().then(function(){
                        flash.success = 'Note saved';
                        $location.path("/#/index");
                    });
                } else {
                    Restangular.all('notes').post($scope.note).then(function(note) {
                        flash.success = 'Note created';
                        $location.path("/#/index");
                    });
                }
            };
}]);