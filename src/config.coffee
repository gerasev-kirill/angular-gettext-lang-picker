angular.module('ui.gettext.langPicker')




.config ($provide, $stateProvider) ->
    # http://stackoverflow.com/questions/24972750/angular-ui-router-default-parameter
    $provide.decorator '$state', ($delegate, $langPicker) ->
        state = $delegate
        baseGo = state.go

        state.go = (to, params, options) ->
            params = params  or  {}
            params.lang = $langPicker.currentLang
            baseGo(to, params, options)

        # оборачиваем также и вызов href.
        # если переменная lang не определена, то url будет сгенерирован
        # такого вида "//my/state" что не даст браузеру нормально открывать
        # ссылки по щелчку средней кнопки.
        baseHref = state.href
        state.href = (stateOrName, params, options)->
            params = params  or  {}
            url = baseHref(stateOrName, params, options)
            if not params.lang  and  url
                url = url.replace('//', '/')
            url

        state

    # http://stackoverflow.com/questions/29892353/angular-ui-router-resolve-state-from-url/30926025#30926025
    $stateProvider.decorator 'parent', (internalStateObj, parentFn)->
        internalStateObj.self.$$state = ()-> internalStateObj
        parentFn(internalStateObj)
