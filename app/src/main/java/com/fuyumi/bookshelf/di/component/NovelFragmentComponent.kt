package com.fuyumi.bookshelf.di.component

import com.fuyumi.bookshelf.di.FragmentScope
import com.fuyumi.bookshelf.ui.fragment.NovelFragment
import dagger.Subcomponent

@FragmentScope
@Subcomponent
interface NovelFragmentComponent {
    fun inject(androidFragment: NovelFragment)

    @Subcomponent.Builder
    interface Builder {
        fun build(): NovelFragmentComponent
    }
}
