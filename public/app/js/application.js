var notesApp = angular.module('notesApp', [
    'ngRoute',
    'restangular',
    'notesControllers'
]);

notesApp.config(['$routeProvider',
    function($routeProvider) {
        $routeProvider.
            when('/index', {
                templateUrl: 'app/views/note-list.html',
                controller: 'NoteListCtrl'
            }).
            when('/phones/:phoneId', {
                templateUrl: 'partials/phone-detail.html',
                controller: 'PhoneDetailCtrl'
            }).
            otherwise({
                redirectTo: '/index'
            });
    }]);

notesApp.config(function(RestangularProvider) {
    RestangularProvider.setBaseUrl('/api');
    RestangularProvider.addResponseInterceptor(function(data, operation, what, url, response, deferred) {
        var extractedData;
        if (operation === "getList") {
            extractedData = data.notes;
        } else {
            extractedData = data.note;
        }
        return extractedData;
    });
});