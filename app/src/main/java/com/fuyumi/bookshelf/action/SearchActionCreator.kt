package com.fuyumi.bookshelf.action

import com.johnny.rxflux.Action
import javax.inject.Inject

class SearchActionCreator
    @Inject constructor() {

    private var hasAction = false

    fun getSearchResult() {
        val action = Action.type(ActionType.GET_SEARCH_LIST).build()
        if (hasAction) return
        hasAction = true

    }

}
