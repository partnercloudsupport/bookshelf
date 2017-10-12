package com.fuyumi.bookshelf.store

import com.fuyumi.bookshelf.action.ActionKey
import com.johnny.rxflux.Action
import com.johnny.rxflux.Store
import javax.inject.Inject

class SearchStore
    @Inject constructor(): Store() {


        override fun onAction(action: Action?): Boolean {
//            action.get(ActionKey.SEARCH_RESULT)
            return true
        }

        override fun onError(action: Action?, throwable: Throwable?) = true
    }
