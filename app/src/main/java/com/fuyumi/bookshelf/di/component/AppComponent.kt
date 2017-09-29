package com.fuyumi.bookshelf.di.component

import com.fuyumi.bookshelf.di.module.AppModule
import android.content.Context
import dagger.Component
import javax.inject.Singleton

@Singleton
@Component(modules = arrayOf(AppModule::class))
interface AppComponent {
    val appContext: Context

    fun mainActivityComponent(): MainActivityComponent.Builder
    fun searchActivityComponent(): SearchActivityComponent.Builder
}
