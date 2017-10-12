package com.fuyumi.bookshelf.util

import android.content.res.Resources

fun getResString(resId: Int): String {
    return Resources.getSystem().getString(resId)
}
