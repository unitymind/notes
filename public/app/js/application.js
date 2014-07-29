var notesApp = angular.module('notesApp', [
    'ngRoute',
    'restangular',
    'notesAnimations',
    'notesControllers'
]);

notesApp.config(['$routeProvider',
    function($routeProvider) {
        $routeProvider.
            when('/index', {
                templateUrl: 'app/views/note-list.html',
                controller: 'NoteListCtrl'
            }).
            when('/new', {
                templateUrl: 'app/views/note-form.html',
                controller: 'NoteFormCtrl'
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