package com.fuyumi.bookshelf.di.component

import android.app.Activity
import com.fuyumi.bookshelf.di.ActivityScoped
import com.fuyumi.bookshelf.di.module.FragmentBindModule
import dagger.BindsInstance
import dagger.Subcomponent

/**
 * Created by fuyumi on 2017/9/24 0024.
 */

@ActivityScoped
@Subcomponent(modules = arrayOf(FragmentBindModule::class))
interface MainActivityComponent {
    @Subcomponent.Builder
    interface Builder {
        @BindsInstance
        fun activity(activity: Activity): Builder
        fun build(): MainActivityComponent
    }
}
