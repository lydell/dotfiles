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



let map = (shortcuts, command, custom=false) => {
  vimfx.set(`${custom ? 'custom.' : ''}mode.normal.${command}`, shortcuts)
}

map('', 'go_home')
map('', 'stop')

map('<late><left>',  'scroll_left')
map('<late><right>', 'scroll_right')
map('<late><down>',  'scroll_down')
map('<late><up>',    'scroll_up')

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
map('ae',    'follow_multiple')
map('ye',    'follow_copy')
map('ze',    'follow_focus')

map('I', 'enter_mode_ignore')
map('i', 'quote')



vimfx.set('hint_chars', 'ehstirnoamupcwlfgdy')
vimfx.set('prevent_autofocus', true)
