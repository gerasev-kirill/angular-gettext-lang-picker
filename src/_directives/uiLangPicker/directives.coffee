###*
*   @ngdoc directive
*   @name ui.gettext.langPicker.directive:uiLangPicker
*   @description language picker directive for bootstrap framework(as button)
*   @restrict E
*   @param {expression=} ngDisabled If the expression is truthy, then the disabled attribute will be set on the element
*   @example
*       <pre>
*           //html
*           <ui-lang-picker></ui-lang-picker>
*       </pre>
*       Output:
*       <div style="margin-bottom: 2em;">
*           <img src="img/uiLangPicker.jpg"/>
*       </div>
###
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
