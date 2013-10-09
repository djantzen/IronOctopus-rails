class this.EmbeddedBrowser

  constructor: (@embedded_browser_panel) ->

    @windows = $.map(@embedded_browser_panel.find(".embedded-browser-window"), (value, index) ->
      new EmbeddedBrowserWindow($(value)))
    @init_search_button()

  init_search_button: () ->
    button = @embedded_browser_panel.find(".browser-search-button")
    button.click =>
      query = @embedded_browser_panel.find(".search-input").val()
      $.each(@windows, (index, window) ->
        window.set_search_query(query)
      )

class this.EmbeddedBrowserWindow

  constructor: (@embedded_browser_window_panel) ->
    @pages = []
    @init_back_button()

  init_back_button: () =>
    button = @embedded_browser_window_panel.find(".browser-back-button")
    button.click =>
      if @pages.length > 1
        @pages.pop()
        @render()

  render: () =>
    page = @pages[@pages.length - 1]
    try
      @embedded_browser_window_panel.find(".proxied-page-contents").html(page)
    catch error
    @rewrite_link_event_handlers(@embedded_browser_window_panel.find(".proxied-page-contents"))

  set_search_query: (query) =>
    @pages = []
    proxied_url = @embedded_browser_window_panel.attr("proxied_url")
    fetcher = new URLFetcher(this, proxied_url + "&q=" + encodeURIComponent(query))
    fetcher.go()

  add_page: (page) =>
    @pages.push(page)
    @render()

  rewrite_link_event_handlers: (page)=>
    $.each($(page).find("a"), (index, a_tag)=>
      fetcher = new URLFetcher(this, $(a_tag).attr("href"))
      $(a_tag).click (e)=>
#        e.preventDefault
        fetcher.go()
        false
    )

class this.URLFetcher
  constructor: (@embedded_window, @proxied_url) ->
    @base_url = window.location.origin + "/admin/proxied_pages"

  go: =>
    $.get(@base_url, {"url" : @proxied_url }, (data) =>
      @embedded_window.add_page(data)
    )


$(document).ready ->
  if $(".embedded-browser").size() > 0
    new EmbeddedBrowser($(".embedded-browser:first"))