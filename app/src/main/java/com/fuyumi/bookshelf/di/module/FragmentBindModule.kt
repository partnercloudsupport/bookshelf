package com.fuyumi.bookshelf.di.module

import com.fuyumi.bookshelf.di.component.BookshelfFragmentComponent
import com.fuyumi.bookshelf.di.component.DoujinshiFragmentComponent
import com.fuyumi.bookshelf.di.component.MangaFragmentComponent
import com.fuyumi.bookshelf.di.component.NovelFragmentComponent
import dagger.Module

@Module(subcomponents = arrayOf(BookshelfFragmentComponent::class, MangaFragmentComponent::class, NovelFragmentComponent::class, DoujinshiFragmentComponent::class))
class FragmentBindModule
