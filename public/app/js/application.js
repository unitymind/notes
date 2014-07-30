var notesApp = angular.module('notesApp', [
    'ngRoute',
    'restangular',
    'notesAnimations',
    'notesControllers',
    'angular-flash.service',
    'angular-flash.flash-alert-directive'
]);

notesApp.config(['$routeProvider', 'RestangularProvider',
    function($routeProvider, RestangularProvider) {
        $routeProvider.
            when('/index', {
                templateUrl: 'app/views/note-list.html',
                controller: 'NoteListCtrl'
            }).
            when('/new', {
                templateUrl: 'app/views/note-form.html',
                controller: 'NoteFormCtrl'
            }).
            when('/edit/:noteId', {
                templateUrl: 'app/views/note-form.html',
                controller: 'NoteFormCtrl'
            }).
            otherwise({
                redirectTo: '/index'
            });

        RestangularProvider.setBaseUrl('http://notes-api-test.herokuapp.com/v1');
        RestangularProvider.addResponseInterceptor(function(data, operation, what, url, response, deferred) {
            var extractedData;
            if (what === 'notes') {
                if (operation === "getList") {
                    extractedData = data.notes;
                } else {
                    extractedData = data.note;
                }
            } else {
                extractedData = data;
            }

            return extractedData;
        });

        RestangularProvider.addRequestInterceptor(function(element, operation, what) {
            if (operation === 'remove') {
                return undefined;
            }

            var modifiedData = element;

            switch (what) {
                case 'notes':
                    switch (operation) {
                        case 'put':
                        case 'post':
                            modifiedData = { note: element };
                            break;
                    }
                    break;
            }

            return modifiedData;
        });
    }
]);

notesApp.factory('LocalRestangular', function(Restangular) {
    return Restangular.withConfig(function(RestangularConfigurer) {
        RestangularConfigurer.setBaseUrl('/api');
    });
});