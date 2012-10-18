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

    extractUrlTitleAndBody = (content) ->
      doc = $(browserCompatibleDocumentParser(content))
      ['', doc.find('body')]

    changePage = (title, body) ->
      log(title)
      log(body.html())

      # $('title').replaceWith title
      # $('body').html body.html()

    setContent = (title, body) ->
      changePage title, body

    return @each (i, el)->
      el = $(el)

      el.data('remote', true)
      el.data('type', 'html')

      el.bind 'ajax:complete', (event, xhr, status) ->
        log("Got response with #{status} status")
        log(xhr.responseText)
        setContent extractUrlTitleAndBody(xhr.responseText)...