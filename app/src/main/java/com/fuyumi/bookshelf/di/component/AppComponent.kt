package com.fuyumi.bookshelf.di.component

import com.fuyumi.bookshelf.di.module.AppModule
import android.content.Context
import dagger.Component
import javax.inject.Singleton

/**
 * Created by fuyumi on 2017/9/23 0023.
 */

@Singleton
@Component(modules = arrayOf(AppModule::class))
interface AppComponent {
    val appContext: Context

    fun mainActivityComponent(): MainActivityComponent.Builder
}
