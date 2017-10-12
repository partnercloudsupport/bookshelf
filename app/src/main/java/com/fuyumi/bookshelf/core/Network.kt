package com.fuyumi.bookshelf.core

import com.github.kittinunf.fuel.core.FuelError
import com.github.kittinunf.fuel.core.Response
import com.github.kittinunf.fuel.httpGet
import com.github.kittinunf.fuel.httpPost
import com.github.kittinunf.fuel.rx.rx_responseString
import com.github.kittinunf.result.Result
import io.reactivex.Single
import io.reactivex.schedulers.Schedulers

fun requestToString(
        method: String,
        url: String,
        body: String? = null
): Single<Pair<Response, Result<String, FuelError>>>? {
    if (body == null) return null

    return when (method) {
        "GET" -> url.httpGet().rx_responseString().subscribeOn(Schedulers.io())
        "POST" -> url.httpPost().body(body).rx_responseString().subscribeOn(Schedulers.io())
        else -> null
    }
}
