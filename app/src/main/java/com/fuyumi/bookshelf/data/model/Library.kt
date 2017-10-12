package com.fuyumi.bookshelf.data.model

import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey

open class Library(
        @PrimaryKey var id: Long = 0,
        var bookName: String = "",
        var bookTitle: String = "",
        var bookAuthor: String = "",
        var bookDescription: String = "",
        var downloadedChapter: RealmList<Chapter> = RealmList(),
        var isFavorite: Boolean = false
): RealmObject()
