
/**
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
*/


(function() {

  angular.module('ui.gettext.langPicker', ['uiFlag', 'ui.bootstrap', 'ui.router']);

}).call(this);


/**
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
*/


(function() {

  angular.module('ui.gettext.langPicker').directive('uiLangPicker', function() {
    return {
      restrict: 'E',
      scope: {
        "default": '=?',
        ngDisabled: '=?'
      },
      controller: ["$scope", "$langPicker", function($scope, $langPicker) {
        $scope.$langPicker = $langPicker;
        if (!$langPicker.currentLang) {
          $langPicker.detectLanguage($scope["default"]);
        }
        return $scope.countryFlagCode = function(lang) {
          if ($langPicker.languageCodeToCountryCodeMapping[lang]) {
            return $langPicker.languageCodeToCountryCodeMapping[lang];
          }
          return lang;
        };
      }],
      template: ('/src/_directives/uiLangPicker/uiLangPicker.html', '\n<div class="btn-group" uib-dropdown="uib-dropdown">\n  <button class="btn btn-default" type="button" uib-dropdown-toggle="uib-dropdown-toggle" ng-disabled="ngDisabled">\n    <flag country="{{countryFlagCode($langPicker.currentLang)}}"></flag>{{$langPicker.getCurrentLanguageName() || \'Language\'}}<span class="caret" style="margin-left:3px;"></span>\n  </button>\n  <ul uib-dropdown-menu="" role="menu">\n    <li role="menuitem" ng-repeat="(lang_code, lang_name) in $langPicker.languageList" ng-click="$langPicker.setCurrentLanguage(lang_code)" ng-class="{\'active\': lang_code==$langPicker.currentLang}"><a href="javascript: void 0">   \n        <flag country="{{countryFlagCode(lang_code)}}"></flag>{{lang_name}}</a></li>\n  </ul>\n</div>' + '')
    };
  });

}).call(this);


/**
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
 */

(function() {
  angular.module('ui.gettext.langPicker').directive('uiLangPickerForNavbar', ["$langPicker", function($langPicker) {
    return {
      restrict: 'A',
      replace: true,
      controller: ["$scope", "$attrs", "$langPicker", "$state", function($scope, $attrs, $langPicker, $state) {
        $scope.$state = $state;
        $scope.$langPicker = $langPicker;
        $scope.attrs = $attrs;
        if (!$langPicker.currentLang) {
          $langPicker.detectLanguage();
        }
        return $scope.countryFlagCode = function(lang) {
          if ($langPicker.languageCodeToCountryCodeMapping[lang]) {
            return $langPicker.languageCodeToCountryCodeMapping[lang];
          }
          return lang;
        };
      }],
      template: ('/src/_directives/uiLangPickerForNavbar/uiLangPickerForNavbar.html', '\n<li class="dropdown" uib-dropdown=""><a class="dropdown-toggle" uib-dropdown-toggle="" style="cursor:pointer;" ng-disabled="attrs.disabled">\n    <flag country="{{countryFlagCode($langPicker.currentLang)}}"></flag>{{$langPicker.getCurrentLanguageName() || \'Language\'}}<span class="caret" style="margin-left:3px;"></span></a>\n  <ul class="dropdown-menu" uib-dropdown-menu="" role="menu">\n    <li role="menuitem" ng-repeat="(lang_code, lang_name) in $langPicker.languageList" ng-click="$langPicker.setCurrentLanguage(lang_code)" ng-class="{\'active\': lang_code==$langPicker.currentLang}"><a href="javascript: void 0">   \n        <flag country="{{countryFlagCode(lang_code)}}"></flag>{{lang_name}}</a></li>\n  </ul>\n</li>' + '')
    };
  }]);

}).call(this);


/**
*   @ngdoc service
*   @name ui.gettext.langPicker.$langPicker
*   @description configuration service
*/


(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('ui.gettext.langPicker').service('$langPicker', ["$injector", "$rootScope", "gettextCatalog", function($injector, $rootScope, gettextCatalog) {
    var _this = this;
    this._lang_loaded = [];
    /**
    *   @ngdoc property
    *   @name ui.gettext.langPicker.$langPicker#languageList
    *   @propertyOf ui.gettext.langPicker.$langPicker
    *   @description
    *       <label class="label type-hint type-hint-object">object</label>
    *       object with lang-codes and lang-names.
    *   @example
    *       <pre>
    *           $langPicker.languageList = {
    *               en: 'English'
    *           };
    *       </pre>
    */

    this.languageList = {};
    this.languageCodeToCountryCodeMapping = {
      en: 'gb',
      cs: 'cz',
      da: 'dk'
    };
    /**
    *   @ngdoc property
    *   @name ui.gettext.langPicker.$langPicker#languageList
    *   @propertyOf ui.gettext.langPicker.$langPicker
    *   @description
    *       <label class="label type-hint type-hint-string">string</label>
    *       url to JSON catalogue with lazy-loading languages. More {@link https://angular-gettext.rocketeer.be/dev-guide/lazy-loading/ here}
    *   @example
    *       <pre>
    *           $langPicker.remoteCatalogUrl = "/my/path";
    *       </pre>
    */

    this.remoteCatalogUrl = '';
    /**
    *   @ngdoc property
    *   @name ui.gettext.langPicker.$langPicker#currentLang
    *   @propertyOf ui.gettext.langPicker.$langPicker
    *   @description
    *       <label class="label type-hint type-hint-string">string</label>
    *       user language code in ["en", "ru", "ua", ...]
    */

    this.currentLang = '';
    this.setCurrentLanguage = function(lang) {
      /**
      *   @ngdoc property
      *   @name ui.gettext.langPicker.$langPicker#setCurrentLanguage
      *   @methodOf ui.gettext.langPicker.$langPicker
      *   @description
      *        language setter for gettext(also reload state with lang code)
      *   @param {string} lang lang code from $langPicker.languageList
      */

      var $state, langs, newValue, oldValue, params;
      if (__indexOf.call(Object.keys(_this.languageList), lang) < 0) {
        langs = Object.keys(_this.languageList);
        throw {
          message: "Unknown lang '" + lang + "'. Allowed are:  '" + (langs.join(', ')) + "'."
        };
      }
      oldValue = angular.copy(_this.currentLang);
      newValue = angular.copy(lang);
      _this.currentLang = lang;
      if (__indexOf.call(_this._lang_loaded, lang) < 0) {
        gettextCatalog.loadRemote(_this.remoteCatalogUrl + lang + ".json");
        _this._lang_loaded.push(lang);
      }
      gettextCatalog.setCurrentLanguage(lang);
      $state = $injector.get('$state');
      if (!$state.current.name) {
        return;
      }
      params = $state.params || {};
      params.lang = lang;
      $state.go($state.current.name, params, {
        notify: false,
        reload: false
      });
      $rootScope.$emit('$langPickerLangChanged', newValue, oldValue);
    };
    this.setLanguageList = function(list) {
      /**
      *   @ngdoc property
      *   @name ui.gettext.langPicker.$langPicker#setLanguageList
      *   @methodOf ui.gettext.langPicker.$langPicker
      *   @description
      *        language list setter.
      *        Please, use language codes from {@link https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes}
      *           (two-letter codes, one per language)
      *   @param {object} list language list
      *   @example
      *   <pre>
      *       $langPicker.setLanguageList({
      *            en: "English",
      *            ru: "Русский",
      *            ua: "Українська",
      *            cz: "Čeština",
      *            de: "Deutsch"
      *       });
      *   </pre>
      */
      return _this.languageList = angular.copy(list);
    };
    this.setLanguageRemoteUrl = function(url) {
      /**
      *   @ngdoc property
      *   @name ui.gettext.langPicker.$langPicker#setLanguageRemoteUrl
      *   @methodOf ui.gettext.langPicker.$langPicker
      *   @description
      *        setter for remoteCatalogUrl
      *   @param {string} url url to JSON catalogue with lazy-loading languages. More {@link https://angular-gettext.rocketeer.be/dev-guide/lazy-loading/ here}
      */
      return _this.remoteCatalogUrl = angular.copy(url);
    };
    this.getCurrentLanguageName = function() {
      /**
      *   @ngdoc property
      *   @name ui.gettext.langPicker.$langPicker#getCurrentLanguageName
      *   @methodOf ui.gettext.langPicker.$langPicker
      *   @description
      *        getter for language name(not code!).
      */

      var _ref;
      if (_ref = _this.currentLang, __indexOf.call(Object.keys(_this.languageList), _ref) < 0) {
        return '';
      }
      return _this.languageList[_this.currentLang];
    };
    this.detectLanguage = function(defaultLang) {
      /**
      *   @ngdoc property
      *   @name ui.gettext.langPicker.$langPicker#detectLanguage
      *   @methodOf ui.gettext.langPicker.$langPicker
      *   @description
      *        language detector(ui.router or window.navigator object)
      */

      var $location, $state, allowedLangs, l, lang, languages, params, s, state, url, _i, _j, _len, _len1, _ref, _ref1;
      $state = $injector.get('$state');
      $location = $injector.get('$location');
      allowedLangs = Object.keys(_this.languageList);
      url = $location.url();
      _ref = $state.get();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        state = _ref[_i];
        if (!state.$$state) {
          continue;
        }
        s = state.$$state();
        params = s.url.exec(url) || s.url.exec(url.split('?')[0]) || {};
        if (params.lang && (_ref1 = params.lang, __indexOf.call(allowedLangs, _ref1) >= 0)) {
          return _this.setCurrentLanguage(params.lang);
        }
      }
      languages = window.navigator.languages || [window.navigator.language || window.navigator.userLanguage];
      for (_j = 0, _len1 = languages.length; _j < _len1; _j++) {
        l = languages[_j];
        l = l.split('-')[0];
        if (__indexOf.call(allowedLangs, l) >= 0) {
          return _this.setCurrentLanguage(l);
        }
      }
      if (__indexOf.call(allowedLangs, defaultLang) >= 0) {
        lang = defaultLang;
      } else {
        lang = allowedLangs[0];
      }
      _this.setCurrentLanguage(lang);
    };
    return this;
  }]);

}).call(this);

(function() {

  angular.module('ui.gettext.langPicker').config(["$provide", "$stateProvider", function($provide, $stateProvider) {
    $provide.decorator('$state', ["$delegate", "$langPicker", function($delegate, $langPicker) {
      var baseGo, baseHref, state;
      state = $delegate;
      baseGo = state.go;
      state.go = function(to, params, options) {
        params = params || {};
        params.lang = $langPicker.currentLang;
        return baseGo(to, params, options);
      };
      baseHref = state.href;
      state.href = function(stateOrName, params, options) {
        var url;
        params = params || {};
        url = baseHref(stateOrName, params, options);
        if (!params.lang && url) {
          url = url.replace('//', '/');
        }
        return url;
      };
      return state;
    }]);
    return $stateProvider.decorator('parent', function(internalStateObj, parentFn) {
      internalStateObj.self.$$state = function() {
        return internalStateObj;
      };
      return parentFn(internalStateObj);
    });
  }]);

}).call(this);
