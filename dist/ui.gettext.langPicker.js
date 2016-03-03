(function() {
  var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('ui.gettext.langPicker', ['uiFlag', 'ui.bootstrap', 'ui.router']).config(["$provide", function($provide) {
    return $provide.decorator('$state', ["$delegate", "$langPickerConf", function($delegate, $langPickerConf) {
      var go, state;
      state = $delegate;
      state.baseGo = state.go;
      go = function(to, params, options) {
        params.lang = $langPickerConf.currentLang;
        return this.baseGo(to, params, options);
      };
      state.go = go;
      return $delegate;
    }]);
  }]).service('$langPickerConf', ["gettextCatalog", "$location", function(gettextCatalog, $location) {
    this.languageList = [];
    this.currentLang = '';
    this._remote_url = '';
    this._lang_loaded = [];
    this.setCurrentLanguage = (function(_this) {
      return function(lang) {
        var hash, langs, path, pathname, ref, ref1;
        if (indexOf.call(Object.keys(_this.languageList), lang) < 0) {
          langs = Object.keys(_this.languageList);
          throw {
            message: "Unknown lang '" + lang + "'. Allowed are:  '" + (langs.join(', ')) + "'."
          };
        }
        _this.currentLang = lang;
        if (indexOf.call(_this._lang_loaded, lang) < 0) {
          gettextCatalog.loadRemote(_this._remote_url + lang + ".json");
          _this._lang_loaded.push(lang);
        }
        gettextCatalog.setCurrentLanguage(lang);
        pathname = window.location.pathname;
        hash = window.location.hash;
        path = pathname.split('/');
        if (path[1] !== lang && (ref = path[1], indexOf.call(_this._lang_loaded, ref) < 0)) {
          path.splice(1, 0, lang);
        } else if (ref1 = path[1], indexOf.call(_this._lang_loaded, ref1) >= 0) {
          path[1] = lang;
        }
        pathname = path.join('/');
        if (pathname[pathname.length - 1] === '/') {
          pathname = pathname.substring(0, pathname.length - 1);
        }
        history.replaceState('', '', pathname + hash);
        return $location.path(pathname + hash);
      };
    })(this);
    this.setLanguageList = (function(_this) {
      return function(list) {
        return _this.languageList = angular.copy(list);
      };
    })(this);
    this.setLanguageRemoteUrl = (function(_this) {
      return function(url) {
        return _this._remote_url = angular.copy(url);
      };
    })(this);
    this.getCurrentLanguageName = (function(_this) {
      return function() {
        var ref;
        if (ref = _this.currentLang, indexOf.call(Object.keys(_this.languageList), ref) < 0) {
          return '';
        }
        return _this.languageList[_this.currentLang];
      };
    })(this);
    this.detectLanguage = (function(_this) {
      return function() {
        var i, l, languages, len, path, pathname, ref;
        pathname = window.location.pathname;
        path = pathname.split('/');
        if (path[1] !== '' && (ref = path[1], indexOf.call(Object.keys(_this.languageList), ref) >= 0)) {
          _this.setCurrentLanguage(path[1]);
          return;
        }
        languages = window.navigator.languages || [window.navigator.language || window.navigator.userLanguage];
        for (i = 0, len = languages.length; i < len; i++) {
          l = languages[i];
          l = l.split('-')[0];
          if (indexOf.call(Object.keys(_this.languageList), l) >= 0) {
            _this.setCurrentLanguage(l);
            break;
          }
        }
      };
    })(this);
    return this;
  }]).directive('langPicker', ["$langPickerConf", function($langPickerConf) {
    return {
      restrict: 'E',
      scope: {
        "default": '=?',
        ngDisabled: '=?'
      },
      controller: ["$scope", function($scope) {
        $scope.$langPickerConf = $langPickerConf;
        if ($scope["default"]) {
          $langPickerConf.setCurrentLanguage($scope["default"]);
        } else {
          $langPickerConf.detectLanguage();
        }
        return $scope.countryFlagCode = function(lang) {
          if (lang === 'en') {
            return 'gb';
          }
          return lang;
        };
      }],
      template: ('/dist/langPicker.html', '<div uib-dropdown="uib-dropdown" class="btn-group"><button type="button" uib-dropdown-toggle="uib-dropdown-toggle" ng-disabled="ngDisabled" class="btn btn-default"><flag country="{{countryFlagCode($langPickerConf.currentLang)}}"></flag>{{$langPickerConf.getCurrentLanguageName() || \'Language\'}}<span style="margin-left:3px;" class="caret"></span></button><ul uib-dropdown-menu="" role="menu"><li role="menuitem" ng-repeat="(lang_code, lang_name) in $langPickerConf.languageList" ng-click="$langPickerConf.setCurrentLanguage(lang_code)"><a href="javascript: void 0">   <flag country="{{countryFlagCode(lang_code)}}"></flag>{{lang_name}}</a><a href="/{{lang_code}}" style="display:none;"># For google search</a></li></ul></div>' + '')
    };
  }]);

}).call(this);
