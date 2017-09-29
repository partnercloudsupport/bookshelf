package com.fuyumi.bookshelf.di.module

import com.fuyumi.bookshelf.di.component.MainActivityComponent
import dagger.Module

@Module(subcomponents = arrayOf(MainActivityComponent::class))
class ActivityBindModule
