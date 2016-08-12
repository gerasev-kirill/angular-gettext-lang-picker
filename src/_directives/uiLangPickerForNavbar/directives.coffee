###*
*   @ngdoc directive
*   @name ui.gettext.langPicker.directive:uiLangPickerForNavbar
*   @description language picker directive for navbar from bootstrap framework
*   @restrict A
*   @param {expression=} ngDisabled If the expression is truthy, then the disabled attribute will be set on the element
*   @example
*       <pre>
*           //html
*           <ul class="nav navbar-nav">
*              <li ui-lang-picker-for-navbar>
*              ...
*           </ul>
*       </pre>
*       Output:
*       <div style="margin-bottom: 2em;">
*           <img src="img/uiLangPickerForNavbar.jpg"/>
*       </div>
###
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
