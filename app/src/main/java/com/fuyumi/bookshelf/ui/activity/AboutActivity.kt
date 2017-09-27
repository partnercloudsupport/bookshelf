package com.fuyumi.bookshelf.ui.activity

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.View
import com.fuyumi.bookshelf.R
import kotlinx.android.synthetic.main.activity_about.*

class AboutActivity : BaseActivity() {

    companion object {
        @JvmStatic
        fun newIntent(context: Context) = Intent(context, AboutActivity::class.java)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_about)
        setSupportActionBar(toolbar)
        supportActionBar!!.setDisplayShowHomeEnabled(true)
        supportActionBar!!.setDisplayHomeAsUpEnabled(true)
        setTitle(R.string.nav_about)
    }
}
