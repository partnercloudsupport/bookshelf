package com.fuyumi.bookshelf.ui.activity

import android.app.Fragment
import android.support.v7.app.AppCompatActivity
import com.fuyumi.bookshelf.App
import com.fuyumi.bookshelf.di.component.AppComponent

abstract class BaseActivity : AppCompatActivity() {

    fun getAppComponent(): AppComponent {
        return (application as App).getAppComponent()
    }

    fun replaceFragment(containerViewId: Int, fragment: Fragment, tag: String) {
        if (null == fragmentManager.findFragmentByTag(tag)) {
            fragmentManager.beginTransaction()
                    .replace(containerViewId, fragment, tag)
                    .commit()
        }
    }

}
