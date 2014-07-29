angular.module('notesApp').directive('confirmDelete', function(){
    return {
        replace: true,
        templateUrl: 'app/views/deleteConfirmation.html',
        scope: {
            onConfirm: '&'
        },
        controller: function ($scope) {
            $scope.isDeleting = false;
            $scope.startDelete = function() {
                $scope.isDeleting = true;
            };
            $scope.cancel = function() {
                $scope.isDeleting = false;
                $scope.confirm = function() {
                    $scope.onConfirm()
                }
            };
        }
    }
});