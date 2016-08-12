angular.module('ui.gettext.langPicker')






.directive 'uiLangPicker',
    ($langPicker) ->
        restrict: 'E'
        scope:{
            default: '=?',
            ngDisabled: '=?'
        }
        controller: ($scope) ->
            $scope.$langPicker = $langPicker
            if not $langPicker.currentLang
                $langPicker.detectLanguage()

            $scope.countryFlagCode = (lang) ->
                if lang=='en' then return 'gb'
                lang


        templateUrl: '/@@__SOURCE_PATH__/uiLangPicker.html'
