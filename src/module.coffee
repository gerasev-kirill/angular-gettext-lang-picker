angular.module 'ui.gettext.langPicker', ['uiFlag', 'ui.bootstrap', 'ui.router']

.config ($provide) ->
    # http://stackoverflow.com/questions/24972750/angular-ui-router-default-parameter
    $provide.decorator '$state', ($delegate, $langPickerConf) ->
        # Save off delegate to use 'state' locally
        state = $delegate
        # Save off reference to original state.go
        state.baseGo = state.go
        # Decorate the original 'go' to always plug in the userID

        go = (to, params, options) ->
            params = params  or  {}
            params.lang = $langPickerConf.currentLang
            # Invoke the original go
            @baseGo(to, params, options)

        # assign new 'go', decorating the old 'go'
        state.go = go
        $delegate


.service '$langPickerConf',
    (gettextCatalog, $location) ->
        @languageList = []
        @currentLang = ''
        @_remote_url = ''
        @_lang_loaded = []

        @setCurrentLanguage = (lang)=>
            if lang not in Object.keys(@languageList)
                langs = Object.keys(@languageList)
                throw {
                    message: "Unknown lang '#{lang}'. Allowed are:  '#{langs.join(', ')}'."
                }
            @currentLang = lang
            if lang not in @_lang_loaded
                gettextCatalog.loadRemote(@_remote_url + lang + ".json")
                @_lang_loaded.push(lang)
            gettextCatalog.setCurrentLanguage(lang)

            pathname = window.location.pathname
            hash = window.location.hash
            path = pathname.split('/')

            if path[1] != lang and path[1] not in @_lang_loaded
                path.splice(1, 0, lang)
            else if path[1] in @_lang_loaded
                path[1] = lang

            pathname = path.join('/')
            if pathname[pathname.length-1]=='/'
                pathname = pathname.substring(0, pathname.length-1)

            #history.replaceState('', '', pathname+hash)
            #$location.path(pathname+hash)


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
            languages = window.navigator.languages || [window.navigator.language || window.navigator.userLanguage]
            for l in languages
                l = l.split('-')[0]
                if l in Object.keys(@languageList)
                    @setCurrentLanguage(l)
                    break
            return

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
