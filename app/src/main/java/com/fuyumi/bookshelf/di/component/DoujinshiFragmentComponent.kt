package com.fuyumi.bookshelf.di.component

import com.fuyumi.bookshelf.di.FragmentScope
import com.fuyumi.bookshelf.ui.fragment.DoujinshiFragment
import dagger.Subcomponent

@FragmentScope
@Subcomponent
interface DoujinshiFragmentComponent {
    fun inject(androidFragment: DoujinshiFragment)

    @Subcomponent.Builder
    interface Builder {
        fun build(): DoujinshiFragmentComponent
    }
}
