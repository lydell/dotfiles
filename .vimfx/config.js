// IMPORTS

const {classes: Cc, interfaces: Ci, utils: Cu} = Components
const nsIStyleSheetService = Cc['@mozilla.org/content/style-sheet-service;1']
  .getService(Ci.nsIStyleSheetService)
const globalMessageManager = Cc['@mozilla.org/globalmessagemanager;1']
  .getService(Ci.nsIMessageListenerManager)
const {Preferences} = Cu.import('resource://gre/modules/Preferences.jsm', {})



// OPTIONS

const MAPPINGS = {
  'go_home': '',
  'stop': '',

  'scroll_left':  '<late><left>',
  'scroll_right': '<late><right>',
  'scroll_down':  '<late><down>',
  'scroll_up':    '<late><up>',
  'mark_scroll_position': 'gm',

  'tab_select_previous': 's',
  'tab_select_next':     'h',
  'tab_move_backward': 'gs',
  'tab_move_forward':  'gh',
  'tab_move_to_index': ['gS', 'custom.mode.normal'],
  'tab_close':   'c',
  'tab_restore': 'C',
  'toggle_floating_tab_bar': ['m', 'custom.mode.normal'],
  'toggle_fixed_tab_bar':    ['M', 'custom.mode.normal'],

  'follow':                   'e',
  'follow_in_tab':            'E',
  'follow_in_focused_tab':    '<force><c-e>',
  'follow_in_window':         'fw',
  'follow_in_private_window': 'fp',
  'open_context_menu':        'fc',
  'follow_multiple':          'ae',
  'follow_copy':              'ye',
  'follow_focus':             'fe',
  'click_browser_element':    'l',

  'enter_mode_ignore':  'I',
  'quote':              'i',
  'youtube_view_video': ['gv', 'custom.mode.normal'],

  'move_left':  ['<left>',  'mode.caret'],
  'move_right': ['<right>', 'mode.caret'],
  'move_down':  ['<down>',  'mode.caret'],
  'move_up':    ['<up>',    'mode.caret'],
}

const VIMFX_PREFS = {
  'hints.chars': 'ehstirnoamupcwlfg dy',
  'prevent_autofocus': true,
  'prev_patterns': v => `föregående  ${v}`,
  'next_patterns': v => `nästa  ${v}`,
}

const FIREFOX_PREFS = {
  'accessibility.blockautorefresh': true,
  'browser.ctrlTab.previews': true,
  'browser.fixup.alternate.enabled': false,
  'browser.search.suggest.enabled': false,
  'browser.startup.page': 3,
  'browser.tabs.animate': false,
  'browser.tabs.closeWindowWithLastTab': false,
  'browser.tabs.warnOnClose': false,
  'browser.urlbar.formatting.enabled': false,
  'devtools.chrome.enabled': true,
  'devtools.command-button-eyedropper.enabled': true,
  'devtools.command-button-rulers.enabled': true,
  'devtools.selfxss.count': 0,
  'privacy.donottrackheader.enabled': true,
}

const CSS = [
  `${__dirname}/chrome.css`,
  `${__dirname}/content.css`,
  `${__dirname}/tabs.css`,
]

const TABBAR_AUTO_SHOW_DURATION = 2000 // ms



// CUSTOM COMMANDS

const {commands} = vimfx.modes.normal

const CUSTOM_COMMANDS = [
  [
    {
      name: 'tab_move_to_index',
      description: 'Move tab to index',
      category: 'tabs',
      order: commands.tab_move_forward.order + 1,
    },
    ({vim, count}) => {
      if (count === undefined) {
        vim.notify('Provide a count')
        return
      }
      const {window} = vim
      window.setTimeout(() => {
        window.gBrowser.moveTabTo(window.gBrowser.selectedTab, count - 1)
      }, 0)
    },
  ],
  [
    {
      name: 'toggle_floating_tab_bar',
      description: 'Toggle floating tab bar',
      category: 'tabs',
    },
    ({vim}) => {
      const {window} = vim
      const value = getWindowAttribute(window, 'tabbar-visibility')
      const isFloating = (!value || value === 'floating' || value === 'temporary')
      setWindowAttribute(window, 'tabbar-visibility', isFloating ? 'hidden' : 'floating')
    },
  ],
  [
    {
      name: 'toggle_fixed_tab_bar',
      description: 'Toggle fixed tab bar',
      category: 'tabs',
    },
    ({vim}) => {
      const {window} = vim
      const isFixed = (getWindowAttribute(window, 'tabbar-visibility') === 'fixed')
      setWindowAttribute(window, 'tabbar-visibility', isFixed ? 'hidden' : 'fixed')
    },
  ],
  [
    {
      name: 'youtube_view_video',
      description: 'View YouTube video',
    },
    ({vim}) => {
      const location = new vim.window.URL(vim.browser.currentURI.spec)
      const match = /v=(\w+)/.exec(location.search)
      if (
        match &&
        location.hostname.endsWith('www.youtube.com') &&
        location.pathname === '/watch'
      ) {
        vim.window.gBrowser.loadURI(`${location.hostname}/embed/${match[1]}`)
      } else {
        vim.notify('No YouTube')
      }
    },
  ],
]



// APPLY THE ABOVE

CUSTOM_COMMANDS.forEach(([options, fn]) => {
  vimfx.addCommand(options, fn)
})

Object.entries(MAPPINGS).forEach(([command, value]) => {
  const [shortcuts, mode] = Array.isArray(value)
    ? value
    : [value, 'mode.normal']
  vimfx.set(`${mode}.${command}`, shortcuts)
})

Object.entries(VIMFX_PREFS).forEach(([pref, valueOrFunction]) => {
  const value = typeof valueOrFunction === 'function'
    ? valueOrFunction(vimfx.getDefault(pref))
    : valueOrFunction
  vimfx.set(pref, value)
})

Preferences.set(FIREFOX_PREFS)

CSS.forEach(uriString => {
  const uri = Services.io.newURI(uriString, null, null)
  const method = nsIStyleSheetService.AUTHOR_SHEET
  if (!nsIStyleSheetService.sheetRegistered(uri, method)) {
    nsIStyleSheetService.loadAndRegisterSheet(uri, method)
  }
  vimfx.on('shutdown', () => {
    nsIStyleSheetService.unregisterSheet(uri, method)
  })
})



// AUTO-HIDE TABBAR

const windows = new WeakSet()
const onTabCreated = ({target: browser}) => {
  if (browser.getAttribute('messagemanagergroup') !== 'browsers') {
    return
  }

  const window = browser.ownerGlobal
  if (!windows.has(window)) {
    windows.add(window)

    const tabsToolbar = window.document.getElementById('TabsToolbar')
    const navigatorToolbox = window.document.getElementById('navigator-toolbox')
    tabsToolbar.style.top = `${navigatorToolbox.clientHeight}px`

    let timeout = null
    const autoShowTabbar = () => {
      const value = getWindowAttribute(window, 'tabbar-visibility')
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



// HELPER FUNCTIONS

function getWindowAttribute(window, name) {
  return window.document.documentElement.getAttribute(`vimfx-config-${name}`)
}

function setWindowAttribute(window, name, value) {
  window.document.documentElement.setAttribute(`vimfx-config-${name}`, value)
}

function listen(window, eventName, listener) {
  window.addEventListener(eventName, listener, true)
  vimfx.on('shutdown', () => {
    window.removeEventListener(eventName, listener, true)
  })
}
