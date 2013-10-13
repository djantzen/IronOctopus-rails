class this.EmbeddedBrowser

  constructor: (@embedded_browser_panel) ->

    @windows = $.map(@embedded_browser_panel.find(".embedded-browser-window"), (value, index) ->
      new EmbeddedBrowserWindow($(value)))
    @init_search_button()
    @init_collapse_results_button()
    @embedded_browser_panel.find(".loading-indicator").hide()

  init_search_button: () ->
    button = @embedded_browser_panel.find(".browser-search-button")
    button.click =>
      query = @embedded_browser_panel.find(".search-input").val()
      $.each(@windows, (index, window) ->
        window.set_search_query(query)
      )

  init_collapse_results_button: () ->
    $("#collapse-search-results").click ->
      $(".embedded-browser-window").addClass("hidden")
    $(".embedded-browser-nav-pill").click ->
      $(".embedded-browser-window").removeClass("hidden")

class this.Page
  constructor: (@url, @contents) ->

class this.EmbeddedBrowserWindow

  constructor: (@embedded_browser_window_panel) ->
    @pages = []
    @init_back_button()
    @init_bookmark_button()

  init_back_button: () =>
    button = @embedded_browser_window_panel.find(".browser-back-button")
    button.attr("disabled", true)
    button.click =>
      if @pages.length > 1
        @pages.pop()
        @render()

  init_bookmark_button: () =>
    button = @embedded_browser_window_panel.find(".browser-bookmark-button")
    button.attr("disabled", true)
    button.click =>
      if @pages.length > 1
        page = @pages[@pages.length - 1]
        # get page url
        empty_image_fields = $(".activity-citation-url").filter ->
          this.value == ""
        $(empty_image_fields[0]).val(page.url)

  render: () =>
    page = @pages[@pages.length - 1]
    @embedded_browser_window_panel.find(".browser-back-button").attr("disabled", @pages.length <= 1);
    @embedded_browser_window_panel.find(".browser-bookmark-button").attr("disabled", @pages.length <= 1);
    try
      @embedded_browser_window_panel.find(".proxied-page-contents").html(page.contents)
      page_contents = @embedded_browser_window_panel.find(".proxied-page-contents")
      @rewrite_link_event_handlers(page_contents)
      @init_video_links(page_contents)
      @init_image_links(page_contents)
      @embedded_browser_window_panel.find(".proxied-page-url").val(page.url)
    catch error

  set_search_query: (query) =>
    @pages = []
    proxied_url = @embedded_browser_window_panel.attr("proxied_url")
    fetcher = new URLFetcher(this, proxied_url + "&q=" + encodeURIComponent(query))
    fetcher.go()

  add_page: (page) =>
    @pages.push(page)
    @render()

  rewrite_link_event_handlers: (page_contents)=>
    $.each($(page_contents).find("a"), (index, a_tag)=>
      fetcher = new URLFetcher(this, $(a_tag).attr("href"))
      $(a_tag).click (e)=>
        fetcher.go()
        false
    )

  init_video_links: (page_contents)=>
    $(page_contents).find(".video-wrapper button").click ->
      link = $(this).siblings("a:first").attr("href")
      $("#activity-video-link").val(link)

  init_image_links: (page_contents)=>
    $(page_contents).find(".image-wrapper button").click ->
      link = $(this).siblings("a:first").attr("href") or $(this).siblings("img:first").attr("src")
      empty_image_fields = $(".image-url-input").filter ->
        this.value == ""
      $(empty_image_fields[0]).val(link)

class this.URLFetcher
  constructor: (@embedded_window, @proxied_url) ->
    @base_url = window.location.origin + "/admin/proxied_pages"

  go: =>
    $(".loading-indicator").show()
    $.get(@base_url, { "url" : @proxied_url },
      (data, status, data_type) =>
        @embedded_window.add_page(new Page(@proxied_url, data))
        $(".loading-indicator").hide()
    ).fail( ->
      $(".loading-indicator").hide()
      # show error message
    )


$(document).ready ->
  if $(".embedded-browser").size() > 0
    new EmbeddedBrowser($(".embedded-browser:first"))