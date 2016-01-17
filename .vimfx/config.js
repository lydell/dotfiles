let {commands} = vimfx.modes.normal

vimfx.addCommand({
  name: 'open_tab_next_to_current',
  description: 'New tab next to current',
  category: 'tabs',
  order: commands.tab_new.order + 1,
}, (args) => {
  let {vim} = args
  let {gBrowser} = vim.window
  let newTabPosition = gBrowser.selectedTab._tPos + 1
  commands.tab_new.run(args)
  vim.window.setTimeout(() => {
    gBrowser.moveTabTo(gBrowser.selectedTab, newTabPosition)
  }, 0)
})

vimfx.addCommand({
  name: 'toggle_treestyletab_tab_bar',
  description: 'Toggle TreeStyleTab tab bar',
  category: 'tabs',
}, ({vim}) => {
  let {gBrowser} = vim.window
  if (gBrowser.treeStyleTab.tabbarShown) {
    gBrowser.treeStyleTab.hideTabbar()
  } else {
    gBrowser.treeStyleTab.showTabbar()
  }
})

vimfx.addCommand({
  name: 'noscript_click_toolbar_button',
  description: 'NoScript',
}, ({vim}) => {
  let button = vim.window.document.getElementById('noscript-tbb')
  button.click()
  let menuitems = button.querySelectorAll('menuitem')
  Array.forEach(menuitems, menuitem => {
    let match = /^(\S+(?:\s+\S+)*)\s+(\S+\.\S+)(?:\s+(\S+))?/.exec(menuitem.label)
    if (match) {
      menuitem.label = `${match[2]} – ${match[1]} ${match[3] || ''}`.trim()
    }
  })
})

vimfx.addCommand({
  name: 'youtube_view_video',
  description: 'View YouTube video',
}, ({vim}) => {
  let location = new vim.window.URL(vim.browser.currentURI.spec)
  let match = /v=(\w+)/.exec(location.search)
  if (
    match &&
    location.hostname.endsWith('www.youtube.com') &&
    location.pathname === '/watch'
  ) {
    vim.window.gBrowser.loadURI(`${location.hostname}/embed/${match[1]}`)
  } else {
    vim.notify('No YouTube')
  }
})



let map = (shortcuts, command, custom=false) => {
  vimfx.set(`${custom ? 'custom.' : ''}mode.normal.${command}`, shortcuts)
}

map('', 'go_home')
map('', 'stop')

map('<late><left>',  'scroll_left')
map('<late><right>', 'scroll_right')
map('<late><down>',  'scroll_down')
map('<late><up>',    'scroll_up')
map('gm', 'mark_scroll_position')

map('gt', 'open_tab_next_to_current', true)
map('s',  'tab_select_previous')
map('h',  'tab_select_next')
map('gs', 'tab_move_backward')
map('gh', 'tab_move_forward')
map('c',  'tab_close')
map('C',  'tab_restore')
map('m',  'toggle_treestyletab_tab_bar', true)

map('e',     'follow')
map('E',     'follow_in_tab')
map('<c-e>', 'follow_in_focused_tab')
map('gE',    'follow_in_window')
map('ae',    'follow_multiple')
map('ye',    'follow_copy')
map('ze',    'follow_focus')
map('l',     'click_browser_element')

map('I',  'enter_mode_ignore')
map('i',  'quote')
map('f',  'noscript_click_toolbar_button', true)
map('gv', 'youtube_view_video', true)



let set = (pref, valueOrFunction) => {
  let value = typeof valueOrFunction === 'function'
    ? valueOrFunction(vimfx.getDefault(pref))
    : valueOrFunction
  vimfx.set(pref, value)
}

set('hint_chars', 'ehstirnoamupcwlfgdy')
set('prevent_autofocus', true)
set('prev_patterns', v => `föregående  ${v}`)
set('next_patterns', v => `nästa  ${v}`)
