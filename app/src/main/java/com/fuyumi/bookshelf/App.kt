package com.fuyumi.bookshelf

import android.app.Application
import com.fuyumi.bookshelf.di.component.AppComponent
import com.fuyumi.bookshelf.di.component.DaggerAppComponent
import com.fuyumi.bookshelf.di.module.AppModule
import com.squareup.leakcanary.LeakCanary
import com.squareup.leakcanary.RefWatcher


class App : Application() {

    private lateinit var appComponent: AppComponent

    override fun onCreate() {
        super.onCreate()

        setupLeakCanary()

        initInjector()
    }

    private fun setupLeakCanary(): RefWatcher {
        return if (LeakCanary.isInAnalyzerProcess(this)) {
            RefWatcher.DISABLED
        } else LeakCanary.install(this)
    }

    private fun initInjector() {
        appComponent = DaggerAppComponent.builder()
                .appModule(AppModule(this))
                .build()
    }

    fun getAppComponent(): AppComponent = appComponent
}
