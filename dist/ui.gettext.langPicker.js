(function() {
  angular.module('ui.gettext.langPicker', ['uiFlag', 'ui.bootstrap', 'ui.router']);

}).call(this);

(function() {
  angular.module('ui.gettext.langPicker').directive('uiLangPicker', ["$langPicker", function($langPicker) {
    return {
      restrict: 'E',
      scope: {
        "default": '=?',
        ngDisabled: '=?'
      },
      controller: ["$scope", function($scope) {
        $scope.$langPicker = $langPicker;
        if (!$langPicker.currentLang) {
          $langPicker.detectLanguage();
        }
        return $scope.countryFlagCode = function(lang) {
          if (lang === 'en') {
            return 'gb';
          }
          return lang;
        };
      }],
      template: ('/src/_directives/uiLangPicker/uiLangPicker.html', '\n<div uib-dropdown="uib-dropdown" class="btn-group">\n  <button type="button" uib-dropdown-toggle="uib-dropdown-toggle" ng-disabled="ngDisabled" class="btn btn-default">\n    <flag country="{{countryFlagCode($langPicker.currentLang)}}"></flag>{{$langPicker.getCurrentLanguageName() || \'Language\'}}<span style="margin-left:3px;" class="caret"></span>\n  </button>\n  <ul uib-dropdown-menu="" role="menu">\n    <li role="menuitem" ng-repeat="(lang_code, lang_name) in $langPicker.languageList" ng-click="$langPicker.setCurrentLanguage(lang_code)" ng-class="{\'active\': lang_code==$langPicker.currentLang}"><a href="javascript: void 0">   \n        <flag country="{{countryFlagCode(lang_code)}}"></flag>{{lang_name}}</a></li>\n  </ul>\n</div>' + '')
    };
  }]);

}).call(this);

(function() {
  angular.module('ui.gettext.langPicker').directive('uiLangPickerForNavbar', ["$langPicker", function($langPicker) {
    return {
      restrict: 'A',
      replace: true,
      link: function($scope, $element, attrs) {
        $scope.$langPicker = $langPicker;
        $scope.attrs = attrs;
        if (!$langPicker.currentLang) {
          $langPicker.detectLanguage();
        }
        return $scope.countryFlagCode = function(lang) {
          if (lang === 'en') {
            return 'gb';
          }
          return lang;
        };
      },
      template: ('/src/_directives/uiLangPickerForNavbar/uiLangPickerForNavbar.html', '\n<li uib-dropdown="" class="dropdown"><a uib-dropdown-toggle="" style="cursor:pointer;" ng-disabled="attrs.disabled" class="dropdown-toggle">\n    <flag country="{{countryFlagCode($langPicker.currentLang)}}"></flag>{{$langPicker.getCurrentLanguageName() || \'Language\'}}<span style="margin-left:3px;" class="caret"></span></a>\n  <ul uib-dropdown-menu="" role="menu" class="dropdown-menu">\n    <li role="menuitem" ng-repeat="(lang_code, lang_name) in $langPicker.languageList" ng-click="$langPicker.setCurrentLanguage(lang_code)" ng-class="{\'active\': lang_code==$langPicker.currentLang}"><a href="javascript: void 0">   \n        <flag country="{{countryFlagCode(lang_code)}}"></flag>{{lang_name}}</a></li>\n  </ul>\n</li>' + '')
    };
  }]);

}).call(this);

(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('ui.gettext.langPicker').service('$langPicker', ["$injector", "gettextCatalog", function($injector, gettextCatalog) {
    this._lang_loaded = [];
    this.languageList = [];
    this.remoteCatalogUrl = '';
    this.currentLang = '';
    this.setCurrentLanguage = (function(_this) {
      return function(lang) {
        var $state, langs, params;
        if (__indexOf.call(Object.keys(_this.languageList), lang) < 0) {
          langs = Object.keys(_this.languageList);
          throw {
            message: "Unknown lang '" + lang + "'. Allowed are:  '" + (langs.join(', ')) + "'."
          };
        }
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
        return $state.go($state.current.name, params, {
          notify: false,
          reload: false
        });
      };
    })(this);
    this.setLanguageList = (function(_this) {
      return function(list) {
        return _this.languageList = angular.copy(list);
      };
    })(this);
    this.setLanguageRemoteUrl = (function(_this) {
      return function(url) {
        return _this.remoteCatalogUrl = angular.copy(url);
      };
    })(this);
    this.getCurrentLanguageName = (function(_this) {
      return function() {
        var _ref;
        if (_ref = _this.currentLang, __indexOf.call(Object.keys(_this.languageList), _ref) < 0) {
          return '';
        }
        return _this.languageList[_this.currentLang];
      };
    })(this);
    this.detectLanguage = (function(_this) {
      return function() {
        var $state, l, languages, params, _i, _len;
        $state = $injector.get('$state');
        params = $state.params || {};
        if (params.lang) {
          return _this.setCurrentLanguage(params.lang);
        }
        languages = window.navigator.languages || [window.navigator.language || window.navigator.userLanguage];
        for (_i = 0, _len = languages.length; _i < _len; _i++) {
          l = languages[_i];
          l = l.split('-')[0];
          if (__indexOf.call(Object.keys(_this.languageList), l) >= 0) {
            _this.setCurrentLanguage(l);
            break;
          }
        }
      };
    })(this);
    return this;
  }]);

}).call(this);

(function() {
  angular.module('ui.gettext.langPicker').config(["$provide", function($provide) {
    return $provide.decorator('$state', ["$delegate", "$langPicker", function($delegate, $langPicker) {
      var go, href, state;
      state = $delegate;
      state.baseGo = state.go;
      go = function(to, params, options) {
        params = params || {};
        params.lang = $langPicker.currentLang;
        return this.baseGo(to, params, options);
      };
      state.go = go;
      state.baseHref = state.href;
      href = function(stateOrName, params, options) {
        var url;
        params = params || {};
        url = this.baseHref(stateOrName, params, options);
        if (!params.lang && url) {
          url = url.replace('//', '/');
        }
        return url;
      };
      state.href = href;
      return $delegate;
    }]);
  }]);

}).call(this);
