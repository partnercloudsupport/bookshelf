package com.fuyumi.bookshelf.di.component

import android.app.Activity
import com.fuyumi.bookshelf.di.ActivityScoped
import com.fuyumi.bookshelf.ui.activity.SearchActivity
import dagger.BindsInstance
import dagger.Subcomponent

@ActivityScoped
@Subcomponent
interface SearchActivityComponent {
    fun inject(searchActivity: SearchActivity)

    @Subcomponent.Builder
    interface Builder {
        @BindsInstance
        fun activity(activity: Activity): Builder
        fun build(): SearchActivityComponent
    }
}
