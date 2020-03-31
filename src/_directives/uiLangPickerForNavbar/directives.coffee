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




.directive 'uiLangPickerForNavbar', ($langPicker) ->
    angular.element(document).find('head').prepend("""
    <style type="text/css">
        li.force-ng-hide[ui-lang-picker-for-navbar]{
            display: none;
        }
    </style>
    """)
    restrict: 'A'
    replace: true
    controller: ($scope, $attrs, $element, $langPicker, $state) ->
        $scope.$state = $state
        $scope.$langPicker = $langPicker
        $scope.attrs = $attrs

        if not $langPicker.currentLang
            $langPicker.detectLanguage()

        $scope.countryFlagCode = (lang) ->
            if $langPicker.languageCodeToCountryCodeMapping[lang]
                return $langPicker.languageCodeToCountryCodeMapping[lang]
            lang

        $scope.$watch '$langPicker.languageList',
            (languageList, oldValue)->
                langs = Object.keys(languageList or {})
                if langs.length <= 1
                    $element.addClass('force-ng-hide')
                else
                    $element.removeClass('force-ng-hide')
                if $langPicker.currentLang and !langs.includes($langPicker.currentLang)
                    $langPicker.detectLanguage()
                return
            ,
            true

    templateUrl: '/@@__SOURCE_PATH__/uiLangPickerForNavbar.html'
