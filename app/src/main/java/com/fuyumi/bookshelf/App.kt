package com.fuyumi.bookshelf

import android.app.Application
import com.fuyumi.bookshelf.di.component.AppComponent
import com.fuyumi.bookshelf.di.component.DaggerAppComponent
import com.fuyumi.bookshelf.di.module.AppModule

/**
 * Created by fuyumi on 2017/9/20 0020.
 */

class App : Application() {

    private lateinit var appComponent: AppComponent

    override fun onCreate() {
        super.onCreate()

        initInjector()
    }

    private fun initInjector() {
        appComponent = DaggerAppComponent.builder()
                .appModule(AppModule(this))
                .build()
    }

    fun getAppComponent(): AppComponent = appComponent
}
