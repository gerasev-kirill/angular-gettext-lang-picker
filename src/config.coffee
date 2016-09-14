angular.module('ui.gettext.langPicker')




.config ($provide, $stateProvider) ->
    # http://stackoverflow.com/questions/24972750/angular-ui-router-default-parameter
    $provide.decorator '$state', ($delegate, $langPicker) ->
        state = $delegate
        state.baseGo = state.go

        go = (to, params, options) ->
            params = params  or  {}
            params.lang = $langPicker.currentLang
            @baseGo(to, params, options)

        state.go = go

        # оборачиваем также и вызов href.
        # если переменная lang не определена, то url будет сгенерирован
        # такого вида "//my/state" что не даст браузеру нормально открывать
        # ссылки по щелчку средней кнопки.
        state.baseHref = state.href
        href = (stateOrName, params, options)->
            params = params  or  {}
            url = @baseHref(stateOrName, params, options)
            if not params.lang  and  url
                url = url.replace('//', '/')
            url

        state.href = href

        $delegate

    # http://stackoverflow.com/questions/29892353/angular-ui-router-resolve-state-from-url/30926025#30926025
    $stateProvider.decorator 'parent', (internalStateObj, parentFn)->
        internalStateObj.self.$$state = ()-> internalStateObj
        parentFn(internalStateObj)
