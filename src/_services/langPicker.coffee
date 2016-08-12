angular.module('ui.gettext.langPicker')




.service '$langPicker', ($injector, gettextCatalog)->
    # при инжекте $state прямо в сервис возникает циклическая зависимость
    @_lang_loaded = []
    @languageList = []
    @remoteCatalogUrl = ''
    @currentLang = ''

    @setCurrentLanguage = (lang)=>
        if lang not in Object.keys(@languageList)
            langs = Object.keys(@languageList)
            throw {
                message: "Unknown lang '#{lang}'. Allowed are:  '#{langs.join(', ')}'."
            }
        @currentLang = lang

        if lang not in @_lang_loaded
            gettextCatalog.loadRemote(@remoteCatalogUrl + lang + ".json")
            @_lang_loaded.push(lang)
        gettextCatalog.setCurrentLanguage(lang)

        # перегружаем состояние приложения
        $state = $injector.get('$state')
        if !$state.current.name
            return
        params = $state.params or {}
        params.lang = lang
        $state.go(
            $state.current.name,
            params,
            {notify:false, reload:false}
        )

    @setLanguageList = (list)=>
        @languageList = angular.copy(list)


    @setLanguageRemoteUrl = (url)=>
        @remoteCatalogUrl = angular.copy(url)


    @getCurrentLanguageName = ()=>
        if @currentLang not in Object.keys(@languageList)
            return ''
        @languageList[@currentLang]


    @detectLanguage = ()=>
        $state = $injector.get('$state')
        params = $state.params or {}
        if params.lang
            return @setCurrentLanguage(params.lang)

        languages = window.navigator.languages || [window.navigator.language || window.navigator.userLanguage]
        for l in languages
            l = l.split('-')[0]
            if l in Object.keys(@languageList)
                @setCurrentLanguage(l)
                break
        return


    @
