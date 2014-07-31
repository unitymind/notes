moment.suppressDeprecationWarnings = true;

angular.module('notesApp').filter('fromNow', function() {
    return function(date) {
        return moment(date).fromNow();
    };
});