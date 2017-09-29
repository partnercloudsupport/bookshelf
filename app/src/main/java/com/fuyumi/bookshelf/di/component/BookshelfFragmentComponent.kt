package com.fuyumi.bookshelf.di.component

import com.fuyumi.bookshelf.di.FragmentScope
import com.fuyumi.bookshelf.ui.fragment.BookshelfFragment
import dagger.Subcomponent

@FragmentScope
@Subcomponent
interface BookshelfFragmentComponent {
    fun inject(androidFragment: BookshelfFragment)

    @Subcomponent.Builder
    interface Builder {
        fun build(): BookshelfFragmentComponent
    }
}
