var notesControllers = angular.module('notesControllers', ['restangular']);

notesControllers.controller('NoteListCtrl',
    ['$scope', '$animate', '$location', '$window', 'LocalRestangular', 'Restangular', 'flash',
        function($scope, $animate, $location, $window, LocalRestangular, Restangular, flash) {
            var restErrorsHandler = function(response) {
                if (response.status === 404) {
                    flash.error = 'Note not found!';
                }
                $location.path("/#/index");
            };

            var updateIsEmpty = function() {
                $scope.isEmpty = (_.size($scope.notes) == 0)
            }

            $scope.isEmpty = true;
            $scope.isRefreshing = false;
            $scope.orderField = $window.sessionStorage.getItem('orderField') ? $window.sessionStorage.getItem('orderField') : 'created_at';

            $scope.toggleOrder = function() {
                $scope.orderField = ($scope.orderField === 'created_at') ? '-created_at' : 'created_at';
                $window.sessionStorage.setItem('orderField', $scope.orderField);
            };

            $scope.goToEdit = function(noteId) {
                $location.path("edit/" + noteId);
            };

            $scope.refresh = function() {
                $scope.isRefreshing = true;
                $animate.enabled(false);
                $scope.notes = [];

                if ($window.sessionStorage.getItem('useLocal')) {
                    $scope.restService = LocalRestangular;
                    $scope.useLocal = true;
                } else {
                    $scope.restService = Restangular;
                    $scope.useLocal = false;
                }

                $scope.restService.all('notes').getList().then(function(items) {
                    $scope.notes = items;
                    updateIsEmpty();
                    $scope.isRefreshing = false;
                    $animate.enabled(true);
                });
            };

            $scope.delete = function(note) {
                note.remove().then(function() {
                    flash.success = 'Note deleted';
                    $scope.notes = _.without($scope.notes, note);
                    updateIsEmpty();
                }, restErrorsHandler);
            };

            $scope.toggleStorage = function() {
                if ($scope.useLocal) {
                    $window.sessionStorage.setItem('useLocal', $scope.useLocal);
                    flash.success = 'Switch to local /api';
                } else {
                    $window.sessionStorage.removeItem('useLocal');
                    flash.success = 'Switch to external http://notes-api-test.herokuapp.com/v1';
                }

                $scope.refresh();
            }

            $scope.refresh();
}]).controller('NoteFormCtrl', ['$scope', '$location', '$window', 'LocalRestangular', 'Restangular', 'flash', '$routeParams',
        function($scope, $location, $window, LocalRestangular, Restangular, flash, $routeParams) {
            var restErrorsHandler = function(response) {
                if (response.status === 404) {
                    flash.error = 'Note not found!';
                }
                $location.path("/#/index");
            };

            $scope.restService = $window.sessionStorage.getItem('useLocal') ? LocalRestangular : Restangular;

            if ($routeParams.noteId) {
                $scope.pageHeader = 'Edit your note';
                $scope.restService.one("notes", $routeParams.noteId).get().then(function(item){
                    $scope.note = item
                }, restErrorsHandler);
            } else {
                $scope.note = {}
                $scope.pageHeader = 'Create new note';
            }
            $scope.save = function() {
                if ($routeParams.noteId) {
                    $scope.note.save().then(function(){
                        flash.success = 'Note saved';
                        $location.path("/#/index");
                    }, restErrorsHandler);
                } else {
                    $scope.restService.all('notes').post($scope.note).then(function(note) {
                        flash.success = 'Note created';
                        $location.path("/#/index");
                    }, restErrorsHandler);
                }
            };

            $scope.delete = function(note) {
                note.remove().then(function() {
                    $scope.notes = _.without($scope.notes, note);
                    if (_.size($scope.notes) === 0) {
                        $scope.isEmpty = true;
                    }
                    flash.success = 'Note deleted';
                    $location.path("/#/index");
                }, restErrorsHandler);
            };
}]);