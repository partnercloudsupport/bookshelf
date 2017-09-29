package com.fuyumi.bookshelf.di.component

import com.fuyumi.bookshelf.di.FragmentScope
import com.fuyumi.bookshelf.ui.fragment.MangaFragment
import dagger.Subcomponent

@FragmentScope
@Subcomponent
interface MangaFragmentComponent {
    fun inject(androidFragment: MangaFragment)

    @Subcomponent.Builder
    interface Builder {
        fun build(): MangaFragmentComponent
    }
}
