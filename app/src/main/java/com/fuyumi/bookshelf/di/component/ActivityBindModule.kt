package com.fuyumi.bookshelf.di.component

import dagger.Module

@Module(subcomponents = arrayOf(MainActivityComponent::class, SearchActivityComponent::class))
class ActivityBindModule
