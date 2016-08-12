###*
*   @ngdoc overview
*   @name ui.gettext.langPicker
*   @description
*       Language picker for {@link https://angular-gettext.rocketeer.be }
*   @example
*   <pre>
*       angular.module('MyApp', ['gettext', 'ui.bootstrap', 'ui.router', 'ui.gettext.langPicker'])
*
*       .run(funtion($langPicker){
*            $langPicker.setLanguageList({
*                en: "English",
*                ru: "Русский",
*                ua: "Українська",
*                cz: "Čeština",
*                de: "Deutsch"
*            });
*            $langPicker.detectLanguage();
*       })
*
*       .config(function($stateProvider){
*           $stateProvider.state('app', {
*                abstract: true,
*                url: '/{lang:(?:ru|ua|en|fr|de|cz)}', // or any other lang code
*                template: '<ui-view/>'
*            });
*       })
*
*       // now you can define other states as usual(with prefix 'app' in name). ex.:
*       .config(function($stateProvider){
*           $stateProvider.state('app.hello', {
*                url: '/hello',
*                template: '<hello></hello>'
*            });
*       })
*   </pre>
*   Add directive ui-lang-picker to html:
*   <pre>
*       <ui-lang-picker></ui-lang-picker>
*   </pre>
*   That's it:
*   <div style="margin-bottom:2em;">
*       <img src="img/app.png"/>
*   </div>
###
angular.module 'ui.gettext.langPicker', [
    'uiFlag',
    'ui.bootstrap',
    'ui.router'
]
