package com.fuyumi.bookshelf.ui.activity

import android.os.Bundle
//import android.support.design.widget.Snackbar
import android.support.design.widget.NavigationView
import android.support.v4.view.GravityCompat
import android.support.v7.app.ActionBarDrawerToggle
import android.view.Menu
import android.view.MenuItem
import com.fuyumi.bookshelf.R
import com.fuyumi.bookshelf.di.component.MainActivityComponent
import com.fuyumi.bookshelf.ui.fragment.*
import dagger.Module
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.android.synthetic.main.app_bar_main.*

@Module
class MainActivity : BaseActivity(), NavigationView.OnNavigationItemSelectedListener {

    lateinit var component: MainActivityComponent

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        initInjector()
        setSupportActionBar(toolbar)

//        fab.setOnClickListener { view ->
//            Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
//                    .setAction("Action", null).show()
//        }

        val toggle = ActionBarDrawerToggle(
                this, drawer_layout, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close)
        drawer_layout.addDrawerListener(toggle)
        toggle.syncState()

        nav_view.setNavigationItemSelectedListener(this)

        replaceFragment(R.id.fragment_container, BookshelfFragment.newInstance(), BookshelfFragment.TAG)
        setTitle(R.string.nav_bookshelf)
        nav_view.setCheckedItem(R.id.nav_bookshelf)
    }

    private fun initInjector() {
        component = getAppComponent()
                .mainActivityComponent()
                .activity(this)
                .build()
    }

    override fun onBackPressed() {
        if (drawer_layout.isDrawerOpen(GravityCompat.START)) {
            drawer_layout.closeDrawer(GravityCompat.START)
        } else {
            super.onBackPressed()
        }
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.container_menu, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        if (item.itemId == R.id.search_btn) {
            startActivity(SearchActivity.newIntent(this))
            return true
        }
        return super.onOptionsItemSelected(item)
    }

//    private fun toggleNightmode() {
//
//    }

    override fun onNavigationItemSelected(item: MenuItem): Boolean {
        // Handle navigation view item clicks here.
        when (item.itemId) {
            R.id.nav_bookshelf -> {
                if(null == fragmentManager.findFragmentByTag(BookshelfFragment.TAG)) {
                    replaceFragment(R.id.fragment_container, BookshelfFragment.newInstance(), BookshelfFragment.TAG)
                    setTitle(R.string.nav_bookshelf)
                }
            }
            R.id.nav_manga -> {
                if(null == fragmentManager.findFragmentByTag(MangaFragment.TAG)) {
                    replaceFragment(R.id.fragment_container, MangaFragment.newInstance(), MangaFragment.TAG)
                    setTitle(R.string.nav_manga)
                }
            }
            R.id.nav_novel -> {
                if(null == fragmentManager.findFragmentByTag(NovelFragment.TAG)) {
                    replaceFragment(R.id.fragment_container, NovelFragment.newInstance(), NovelFragment.TAG)
                    setTitle(R.string.nav_novel)
                }
            }
            R.id.nav_doujinshi -> {
                if(null == fragmentManager.findFragmentByTag(DoujinshiFragment.TAG)) {
                    replaceFragment(R.id.fragment_container, DoujinshiFragment.newInstance(), DoujinshiFragment.TAG)
                    setTitle(R.string.nav_doujinshi)
                }
            }
            R.id.nav_themes -> {
                return true
            }
            R.id.nav_nightmode -> {
                return true
            }
            R.id.nav_settings -> {
                startActivity(SettingsActivity.newIntent(this))
            }
            R.id.nav_about -> {
                startActivity(AboutActivity.newIntent(this))
            }
        }

        drawer_layout.closeDrawer(GravityCompat.START)
        return true
    }
}
