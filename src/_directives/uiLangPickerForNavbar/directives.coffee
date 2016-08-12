angular.module('ui.gettext.langPicker')







.directive 'uiLangPickerForNavbar',
    ($langPicker) ->
        restrict: 'A'
        replace: true
        link: ($scope, $element, attrs) ->
            $scope.$langPicker = $langPicker
            $scope.attrs = attrs
            
            if not $langPicker.currentLang
                $langPicker.detectLanguage()

            $scope.countryFlagCode = (lang) ->
                if lang=='en' then return 'gb'
                lang


        templateUrl: '/@@__SOURCE_PATH__/uiLangPickerForNavbar.html'
