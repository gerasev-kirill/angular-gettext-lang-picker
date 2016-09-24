###*
*   @ngdoc service
*   @name ui.gettext.langPicker.$langPicker
*   @description configuration service
###
angular.module('ui.gettext.langPicker')




.service '$langPicker', ($injector, gettextCatalog)->
    @_lang_loaded = []
    ###*
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
    ###
    @languageList = {}
    ###*
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
    ###
    @remoteCatalogUrl = ''
    ###*
    *   @ngdoc property
    *   @name ui.gettext.langPicker.$langPicker#currentLang
    *   @propertyOf ui.gettext.langPicker.$langPicker
    *   @description
    *       <label class="label type-hint type-hint-string">string</label>
    *       user language code in ["en", "ru", "ua", ...]
    ###
    @currentLang = ''

    @setCurrentLanguage = (lang)=>
        ###*
        *   @ngdoc property
        *   @name ui.gettext.langPicker.$langPicker#setCurrentLanguage
        *   @methodOf ui.gettext.langPicker.$langPicker
        *   @description
        *        language setter for gettext(also reload state with lang code)
        *   @param {string} lang lang code from $langPicker.languageList
        ###
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
        # при инжекте $state прямо в сервис возникает циклическая зависимость
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
        return

    @setLanguageList = (list)=>
        ###*
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
        ###
        @languageList = angular.copy(list)


    @setLanguageRemoteUrl = (url)=>
        ###*
        *   @ngdoc property
        *   @name ui.gettext.langPicker.$langPicker#setLanguageRemoteUrl
        *   @methodOf ui.gettext.langPicker.$langPicker
        *   @description
        *        setter for remoteCatalogUrl
        *   @param {string} url url to JSON catalogue with lazy-loading languages. More {@link https://angular-gettext.rocketeer.be/dev-guide/lazy-loading/ here}
        ###
        @remoteCatalogUrl = angular.copy(url)


    @getCurrentLanguageName = ()=>
        ###*
        *   @ngdoc property
        *   @name ui.gettext.langPicker.$langPicker#getCurrentLanguageName
        *   @methodOf ui.gettext.langPicker.$langPicker
        *   @description
        *        getter for language name(not code!).
        ###
        if @currentLang not in Object.keys(@languageList)
            return ''
        @languageList[@currentLang]


    @detectLanguage = ()=>
        ###*
        *   @ngdoc property
        *   @name ui.gettext.langPicker.$langPicker#detectLanguage
        *   @methodOf ui.gettext.langPicker.$langPicker
        *   @description
        *        language detector(ui.router or window.navigator object)
        ###
        $state = $injector.get('$state')
        $location = $injector.get('$location')
        url = $location.url()

        for state in $state.get() when state.$$state
            s = state.$$state()
            params = s.url.exec(url) or {}
            if params.lang
                return @setCurrentLanguage(params.lang)


        languages = window.navigator.languages || [window.navigator.language || window.navigator.userLanguage]
        for l in languages
            l = l.split('-')[0]
            if l in Object.keys(@languageList)
                return @setCurrentLanguage(l)
        keys = Object.keys(@languageList)
        @setCurrentLanguage(keys[0])
        return


    @
