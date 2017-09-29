package com.fuyumi.bookshelf.ui.fragment


import android.os.Bundle

import com.fuyumi.bookshelf.R
import com.fuyumi.bookshelf.di.component.NovelFragmentComponent
import com.fuyumi.bookshelf.ui.activity.MainActivity

class NovelFragment : ContainerFragment() {

    companion object {
        const val TAG = "NovelFragment"
        @JvmStatic
        fun newInstance() = NovelFragment()
    }

    private lateinit var mComponent: NovelFragmentComponent

    private fun initInjector() {
        mComponent = (activity as MainActivity).component
                .novelFragmentComponent()
                .build()
        mComponent.inject(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initInjector()
    }


}
