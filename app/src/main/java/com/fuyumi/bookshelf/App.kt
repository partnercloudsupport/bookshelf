package com.fuyumi.bookshelf

import android.app.Application
import com.facebook.stetho.Stetho
import com.fuyumi.bookshelf.di.component.AppComponent
import com.fuyumi.bookshelf.di.component.DaggerAppComponent
import com.fuyumi.bookshelf.di.module.AppModule
import com.squareup.leakcanary.LeakCanary
import com.squareup.leakcanary.RefWatcher
import com.uphyca.stetho_realm.RealmInspectorModulesProvider
import io.realm.Realm
import io.realm.RealmConfiguration


class App : Application() {

    private lateinit var appComponent: AppComponent

    override fun onCreate() {
        super.onCreate()

        setupLeakCanary()
        initInjector()
        Realm.init(this)
        Realm.setDefaultConfiguration(RealmConfiguration.Builder().name("bookshelf_database.realm").build())
//        Stetho.initializeWithDefaults(this)
        Stetho.initialize(
                Stetho.newInitializerBuilder(this)
                        .enableDumpapp(Stetho.defaultDumperPluginsProvider(this))
                        .enableWebKitInspector(RealmInspectorModulesProvider.builder(this).build())
                        .build()
        )
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
