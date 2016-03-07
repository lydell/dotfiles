const {classes: Cc, interfaces: Ci, utils: Cu} = Components
const nsIStyleSheetService = Cc['@mozilla.org/content/style-sheet-service;1']
  .getService(Ci.nsIStyleSheetService)
const globalMessageManager = Cc['@mozilla.org/globalmessagemanager;1']
  .getService(Ci.nsIMessageListenerManager)

const TABBAR_AUTO_SHOW_DURATION = 2000

let getWindowAttribute = (window, name) => {
  return window.document.documentElement.getAttribute(`vimfx-config-${name}`)
}

let setWindowAttribute = (window, name, value) => {
  window.document.documentElement.setAttribute(`vimfx-config-${name}`, value)
}



let {commands} = vimfx.modes.normal

vimfx.addCommand({
  name: 'tab_move_to_index',
  description: 'Move tab to index',
  category: 'tabs',
  order: commands.tab_move_forward.order + 1,
}, ({vim, count}) => {
  if (count === undefined) {
    vim.notify('Provide a count')
    return
  }
  let {window} = vim
  window.setTimeout(() => {
    window.gBrowser.moveTabTo(window.gBrowser.selectedTab, count - 1)
  }, 0)
})

vimfx.addCommand({
  name: 'toggle_floating_tab_bar',
  description: 'Toggle floating tab bar',
  category: 'tabs',
}, ({vim}) => {
  let {window} = vim
  let value = getWindowAttribute(window, 'tabbar-visibility')
  let isFloating = (!value || value === 'floating' || value === 'temporary')
  setWindowAttribute(window, 'tabbar-visibility', isFloating ? 'hidden' : 'floating')
})

vimfx.addCommand({
  name: 'toggle_fixed_tab_bar',
  description: 'Toggle fixed tab bar',
  category: 'tabs',
}, ({vim}) => {
  let {window} = vim
  let isFixed = (getWindowAttribute(window, 'tabbar-visibility') === 'fixed')
  setWindowAttribute(window, 'tabbar-visibility', isFixed ? 'hidden' : 'fixed')
})

vimfx.addCommand({
  name: 'noscript_click_toolbar_button',
  description: 'NoScript',
}, ({vim}) => {
  let button = vim.window.document.getElementById('noscript-tbb')
  if (!button) return
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

map('s',  'tab_select_previous')
map('h',  'tab_select_next')
map('gs', 'tab_move_backward')
map('gh', 'tab_move_forward')
map('gS', 'tab_move_to_index', true)
map('c',  'tab_close')
map('C',  'tab_restore')
map('m',  'toggle_floating_tab_bar', true)
map('M',  'toggle_fixed_tab_bar', true)

map('e',     'follow')
map('E',     'follow_in_tab')
map('<force><c-e>', 'follow_in_focused_tab')
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



let loadCss = (uriString) => {
  let uri = Services.io.newURI(uriString, null, null)
  let method = nsIStyleSheetService.AUTHOR_SHEET
  if (!nsIStyleSheetService.sheetRegistered(uri, method)) {
    nsIStyleSheetService.loadAndRegisterSheet(uri, method)
  }
  vimfx.on('shutdown', () => {
    nsIStyleSheetService.unregisterSheet(uri, method)
  })
}

loadCss(`${__dirname}/chrome.css`)
loadCss(`${__dirname}/content.css`)
loadCss(`${__dirname}/tabs.css`)



let listen = (window, eventName, listener) => {
  window.addEventListener(eventName, listener, true)
  vimfx.on('shutdown', () => {
    window.removeEventListener(eventName, listener, true)
  })
}

let windows = new WeakSet()
let onTabCreated = ({target: browser}) => {
  if (browser.getAttribute('messagemanagergroup') !== 'browsers') {
    return
  }

  let window = browser.ownerGlobal
  if (!windows.has(window)) {
    windows.add(window)

    let tabsToolbar = window.document.getElementById('TabsToolbar')
    let navigatorToolbox = window.document.getElementById('navigator-toolbox')
    tabsToolbar.style.top = `${navigatorToolbox.clientHeight}px`

    let timeout = null
    let autoShowTabbar = () => {
      let value = getWindowAttribute(window, 'tabbar-visibility')
      if (value === 'hidden' || value === 'temporary') {
        setWindowAttribute(window, 'tabbar-visibility', 'temporary')
        if (timeout) {
          window.clearTimeout(timeout)
        }
        timeout = window.setTimeout(() => {
          if (getWindowAttribute(window, 'tabbar-visibility') === 'temporary') {
            setWindowAttribute(window, 'tabbar-visibility', 'hidden')
            timeout = null
          }
        }, TABBAR_AUTO_SHOW_DURATION)
      }
    }

    listen(window, 'TabSelect', autoShowTabbar)
    listen(window, 'TabOpen', autoShowTabbar)

    setWindowAttribute(window, 'tabbar-visibility', 'temporary')
    autoShowTabbar()
  }
}

globalMessageManager.addMessageListener('VimFx-config:tabCreated', onTabCreated)
vimfx.on('shutdown', () => {
  globalMessageManager.removeMessageListener('VimFx-config:tabCreated', onTabCreated)
})
