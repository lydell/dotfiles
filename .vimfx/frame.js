sendAsyncMessage('VimFx-config:tabCreated')



vimfx.listen('normalizeTwitterLinks', () => {
  Array.forEach(
    content.document.querySelectorAll('a[data-url]'),
    anchor => anchor.href = anchor.dataset.url
  )
})
