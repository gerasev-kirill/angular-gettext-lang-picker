angular.module 'uiGettextLangPicker', ['uiFlag', 'ui.bootstrap']

.service '$langPickerConf',
    (gettextCatalog) ->
        @languageList = []
        @currentLang = ''
        @_remote_url = ''
        @_lang_loaded = []

        @setCurrentLanguage = (lang)=>
            if lang not in Object.keys(@languageList)
                langs = Object.keys(@languageList)
                throw {
                    message: "Unknown lang '#{lang}'. Allowed are:  #{langs.join(', ')}."
                }
            @currentLang = lang
            if lang not in @_lang_loaded
                gettextCatalog.loadRemote(@_remote_url + lang + ".json")
                @_lang_loaded.push(lang)
            gettextCatalog.setCurrentLanguage(lang)
            pathname = window.location.pathname
            hash = window.location.hash
            path = pathname.split('/')
            if path[1] != lang
                path[1] = lang
            pathname = path.join('/')
            if pathname[pathname.length-1]=='/'
                pathname = pathname.substring(0, pathname.length-1)
            history.replaceState('', '', pathname+hash)

        @setLanguageList = (list)=>
            @languageList = angular.copy(list)

        @setLanguageRemoteUrl = (url)=>
            @_remote_url = angular.copy(url)

        @getCurrentLanguageName = ()=>
            if @currentLang not in Object.keys(@languageList)
                return ''
            @languageList[@currentLang]

        @detectLanguage = ()=>
            pathname = window.location.pathname
            path = pathname.split('/')
            if path[1]!='' and path[1] in Object.keys(@languageList)
                @setCurrentLanguage(path[1])
                return
            for l in navigator.languages
                l = l.split('-')[0]
                if l in Object.keys(@languageList)
                    @setCurrentLanguage(l)
                    break

        @



.directive 'langPicker',
    ($langPickerConf) ->
        restrict: 'E'
        scope:{
            default: '=?',
            ngDisabled: '=?'
        }
        controller: ($scope) ->
            $scope.$langPickerConf = $langPickerConf
            if $scope.default
                $langPickerConf.setCurrentLanguage($scope.default)
            else
                $langPickerConf.detectLanguage()

            $scope.countryFlagCode = (lang) ->
                if lang=='en' then return 'gb'
                lang


        templateUrl: '/@@__SOURCE_PATH__/langPicker.html'
