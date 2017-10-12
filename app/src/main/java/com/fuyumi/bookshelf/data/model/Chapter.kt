package com.fuyumi.bookshelf.data.model

import io.realm.RealmObject

open class Chapter: RealmObject() {
    var chapterName: String? = null
}
