var notesControllers = angular.module('notesControllers', ['restangular']);

notesControllers.controller('NoteListCtrl', ['$scope', 'Restangular', function($scope, Restangular) {
    $scope.notes = Restangular.all('notes').getList().$object;

    $scope.delete = function(note) {
        note.remove().then(function() {
            $scope.notes = _.without($scope.notes, note);
        });
    };
}]);