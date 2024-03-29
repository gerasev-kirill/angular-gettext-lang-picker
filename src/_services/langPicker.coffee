###*
*   @ngdoc service
*   @name ui.gettext.langPicker.$langPicker
*   @description configuration service
###
LANG_FALLBACK_MAP = {
    cs: 'cz'
}
angular.module('ui.gettext.langPicker')




.service '$langPicker', ($injector, $rootScope, gettextCatalog)->
    ignoreLoadRemoteLangs = []
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
    @languageCodeToCountryCodeMapping = {
        en: 'gb'
        cs: 'cz'
        da: 'dk'
    }
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

    @setIgnoreLoadRemoteLanguages = (langs)->
        ###*
        *   @ngdoc property
        *   @name ui.gettext.langPicker.$langPicker#setIgnoreLoadRemoteLanguages
        *   @methodOf ui.gettext.langPicker.$langPicker
        *   @description
        *        setter for ignoring languages in gettextCatalog.loadRemote
        *   @param {Array<String>} langs array of lang codes
        ###
        ignoreLoadRemoteLangs = angular.copy(langs)
        return

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

        oldValue = angular.copy(@currentLang)
        newValue = angular.copy(lang)
        @currentLang = lang

        if lang not in @_lang_loaded and lang not in ignoreLoadRemoteLangs
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
        $rootScope.$emit('$langPickerLangChanged', newValue, oldValue)
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


    @detectLanguage = (defaultLang)=>
        ###*
        *   @ngdoc property
        *   @name ui.gettext.langPicker.$langPicker#detectLanguage
        *   @methodOf ui.gettext.langPicker.$langPicker
        *   @description
        *        language detector(ui.router or window.navigator object)
        ###
        $state = $injector.get('$state')
        $location = $injector.get('$location')
        allowedLangs = Object.keys(@languageList)
        url = $location.url()

        for state in $state.get() when state.$$state
            s = state.$$state()
            if !s.url
                continue
            params = s.url.exec(url) or s.url.exec(url.split('?')[0]) or {}
            if params.lang and params.lang in allowedLangs
                return @setCurrentLanguage(params.lang)


        languages = window.navigator.languages || [window.navigator.language || window.navigator.userLanguage]
        for l in languages
            l = l.split('-')[0]
            if LANG_FALLBACK_MAP[l] and LANG_FALLBACK_MAP[l] in allowedLangs
                return @setCurrentLanguage(LANG_FALLBACK_MAP[l])
            if l in allowedLangs
                return @setCurrentLanguage(l)
        if defaultLang in allowedLangs
            lang = defaultLang
        else
            lang = allowedLangs[0]
        @setCurrentLanguage(lang)
        return


    @
