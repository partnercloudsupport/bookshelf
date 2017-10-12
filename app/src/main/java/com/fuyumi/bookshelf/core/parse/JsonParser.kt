package com.fuyumi.bookshelf.core.parse

interface JsonParser {

    val parserName: String
    val baseUrl: String
    val versionId: Int
    val lang: String

    fun searchBook()

}
