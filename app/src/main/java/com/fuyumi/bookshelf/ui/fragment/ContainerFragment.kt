package com.fuyumi.bookshelf.ui.fragment


import android.os.Bundle
import android.support.v4.app.Fragment
import android.support.v4.widget.SwipeRefreshLayout
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView

import com.fuyumi.bookshelf.R

abstract class ContainerFragment : BaseFragment(), SwipeRefreshLayout.OnRefreshListener {

    override fun onRefresh() {}

    protected fun createView(inflater: LayoutInflater, container: ViewGroup): View {
        val contentView = inflater.inflate(R.layout.fragment_container, container, false)

        return contentView
    }

//    override fun onViewCreated(view: View?, savedInstanceState: Bundle?) {
//        super.onViewCreated(view, savedInstanceState)
//
//    }
}
