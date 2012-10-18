$ = jQuery

$.fn.extend
  turboForms: (options) ->
    settings =
      debug: false

    settings = $.extend settings, options

    log = (msg) ->
      console?.log msg if settings.debug

    browserCompatibleDocumentParser = ->
      createDocumentUsingParser = (html) ->
        (new DOMParser).parseFromString html, 'text/html'

      createDocumentUsingWrite = (html) ->
        doc = document.implementation.createHTMLDocument ''
        doc.open 'replace'
        doc.write html
        doc.close
        doc

      if window.DOMParser
        testDoc = createDocumentUsingParser '<html><body><p>test'

      if testDoc?.body?.childNodes.length is 1
        createDocumentUsingParser
      else
        createDocumentUsingWrite

    createDocument = (content) ->
      browserCompatibleDocumentParser content

    extractUrlTitleAndBody = (doc) ->
      title = doc.querySelector 'title'
      [ title?.textContent, doc.body ]

    changePage = (title, body) ->
      log(title)
      log(body)

      document.title = title
      document.documentElement.replaceChild body, document.body

    setContent = (title, body) ->
      changePage title, body

    return @each (i, el)->
      el = $(el)

      el.data('remote', true)
      el.data('type', 'html')

      el.bind 'ajax:complete', (event, xhr, status) ->
        log("Got response with #{status} status")
        log(xhr.responseText)

        doc = createDocument xhr.responseText
        setContent extractUrlTitleAndBody(doc)...