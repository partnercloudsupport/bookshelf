package com.fuyumi.bookshelf.di.module

import android.content.Context
import com.fuyumi.bookshelf.App
import dagger.Module
import dagger.Provides
import okhttp3.Request
import javax.inject.Singleton

@Module
class AppModule(private val app: App) {

    @Provides
    @Singleton
    fun provideApplication(): App = app

    @Provides
    @Singleton
    fun provideContext(): Context = app

}
