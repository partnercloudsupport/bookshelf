package com.fuyumi.bookshelf.ui.fragment


import android.os.Bundle

import com.fuyumi.bookshelf.R
import com.fuyumi.bookshelf.di.component.MangaFragmentComponent
import com.fuyumi.bookshelf.ui.activity.MainActivity

class MangaFragment : ContainerFragment() {

    companion object {
        const val TAG = "MangaFragment"
        @JvmStatic
        fun newInstance() = MangaFragment()
    }

    private lateinit var mComponent: MangaFragmentComponent

    private fun initInjector() {
        mComponent = (activity as MainActivity).component
                .mangaFragmentComponent()
                .build()
        mComponent.inject(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initInjector()
    }


}
