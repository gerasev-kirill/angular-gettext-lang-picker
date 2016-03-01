(function() {
  var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('uiGettextLangPicker', ['uiFlag', 'ui.bootstrap']).service('$langPickerConf', ["gettextCatalog", function(gettextCatalog) {
    this.languageList = [];
    this.currentLang = '';
    this._remote_url = '';
    this._lang_loaded = [];
    this.setCurrentLanguage = (function(_this) {
      return function(lang) {
        var hash, langs, path, pathname;
        if (indexOf.call(Object.keys(_this.languageList), lang) < 0) {
          langs = Object.keys(_this.languageList);
          throw {
            message: "Unknown lang '" + lang + "'. Allowed are:  " + (langs.join(', ')) + "."
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
        if (path[1] !== lang) {
          path[1] = lang;
        }
        pathname = path.join('/');
        if (pathname[pathname.length - 1] === '/') {
          pathname = pathname.substring(0, pathname.length - 1);
        }
        return history.replaceState('', '', pathname + hash);
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
        var i, l, len, path, pathname, ref, ref1, results;
        pathname = window.location.pathname;
        path = pathname.split('/');
        if (path[1] !== '' && (ref = path[1], indexOf.call(Object.keys(_this.languageList), ref) >= 0)) {
          _this.setCurrentLanguage(path[1]);
          return;
        }
        ref1 = navigator.languages;
        results = [];
        for (i = 0, len = ref1.length; i < len; i++) {
          l = ref1[i];
          l = l.split('-')[0];
          if (indexOf.call(Object.keys(_this.languageList), l) >= 0) {
            _this.setCurrentLanguage(l);
            break;
          } else {
            results.push(void 0);
          }
        }
        return results;
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
      templateUrl: '/dist/langPicker.html'
    };
  }]);

}).call(this);
