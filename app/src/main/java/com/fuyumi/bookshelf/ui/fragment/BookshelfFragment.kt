package com.fuyumi.bookshelf.ui.fragment


import android.os.Bundle

import com.fuyumi.bookshelf.R
import com.fuyumi.bookshelf.di.component.BookshelfFragmentComponent
import com.fuyumi.bookshelf.ui.activity.MainActivity

class BookshelfFragment : ContainerFragment() {

    companion object {
        const val TAG = "BookshelfFragment"
        @JvmStatic
        fun newInstance() = BookshelfFragment()
    }

    private lateinit var mComponent: BookshelfFragmentComponent

    private fun initInjector() {
        mComponent = (activity as MainActivity).component
                .bookshelfFragmentComponent()
                .build()
        mComponent.inject(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initInjector()
    }


}
