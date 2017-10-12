package com.fuyumi.bookshelf.source.manga

import com.fuyumi.bookshelf.R
import com.fuyumi.bookshelf.core.parse.JsonParser
import com.fuyumi.bookshelf.util.getResString

class Dmzj : JsonParser {

    override val parserName = getResString(R.string.parser_dmzj)
    override val baseUrl =  "http://v2.api.dmzj.com/"
    override val versionId = 1
    override val lang = "cn"


    override fun searchBook() {

    }

}
