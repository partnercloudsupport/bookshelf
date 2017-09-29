package com.fuyumi.bookshelf.ui.activity

import android.os.Bundle
import android.content.Context
import android.content.Intent
import android.view.View
import com.fuyumi.bookshelf.R
import kotlinx.android.synthetic.main.activity_search.*

class SearchActivity : BaseActivity() {

    companion object {
        @JvmStatic
        fun newIntent(context: Context) = Intent(context, SearchActivity::class.java)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_search)


    }
}
