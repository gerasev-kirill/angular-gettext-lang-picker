# Angular1 language picker directive for gettext
What is gettext for angular? see https://angular-gettext.rocketeer.be/

Depends on ui.bootstrap, ui.router and gettext

Docs: https://gerasev-kirill.github.io/ui.gettext.langPicker/doc

## Installation

```bash
bower install --save ui.gettext.langPicker
```


### Add dependencies to your html

```html
<script src="bower_components/angular/angular.js"/>
<script src="bower_components/angular-gettext/dist/angular-gettext.js"/>
<script src="bower_components/angular-bootstrap/ui-bootstrap-tpls.min.js"/>
<script src="bower_components/ui-flags/dist/uiFlagCss16.min.js"/>
<script src="bower_components/ui.gettext.langPicker/dist/ui.gettext.langPicker.js"/>
```

### Add some js code
```js
   angular.module('MyApp', ['gettext', 'ui.bootstrap', 'ui.router', 'ui.gettext.langPicker'])

   .run(funtion($langPicker){
        $langPicker.setLanguageList({
            en: "English",
            ru: "Русский",
            ua: "Українська",
            cz: "Čeština",
            de: "Deutsch"
        });
        $langPicker.detectLanguage();
   })

   .config(function($stateProvider){
       $stateProvider.state('app', {
            abstract: true,
            url: '/{lang:(?:ru|ua|en|fr|de|cz)}', // or any other lang code
            template: '<ui-view/>'
        });
   })

   // now you can define other states as usual(with prefix 'app' in name). ex.:
   .config(function($stateProvider){
       $stateProvider.state('app.hello', {
            url: '/hello',
            template: '<hello></hello>'
        });
   })
```
Add directive ui-lang-picker to html:
```html
   <ui-lang-picker></ui-lang-picker>
```
That's it:


![app.png](https://github.com/gerasev-kirill/angular-gettext-lang-picker/blob/master/doc/img/app.png)
