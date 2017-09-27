package com.fuyumi.bookshelf.di.module

import android.content.Context
import com.fuyumi.bookshelf.App
import dagger.Module
import dagger.Provides
import javax.inject.Singleton

/**
 * Created by fuyumi on 2017/9/23 0023.
 */

@Module
class AppModule(private val app: App) {
    @Provides
    @Singleton
    fun provideApplication(): App = app

    @Provides
    @Singleton
    fun provideContext(): Context = app
}
