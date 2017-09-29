package com.fuyumi.bookshelf.ui.fragment


import android.os.Bundle

import com.fuyumi.bookshelf.R
import com.fuyumi.bookshelf.di.component.DoujinshiFragmentComponent
import com.fuyumi.bookshelf.ui.activity.MainActivity

class DoujinshiFragment : ContainerFragment() {

    companion object {
        const val TAG = "DoujinshiFragment"
        @JvmStatic
        fun newInstance() = DoujinshiFragment()
    }

    private lateinit var mComponent: DoujinshiFragmentComponent

    private fun initInjector() {
        mComponent = (activity as MainActivity).component
                .doujinshiFragmentComponent()
                .build()
        mComponent.inject(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initInjector()
    }


}
