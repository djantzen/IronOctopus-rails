class this.EmbeddedBrowser

  constructor: (@embedded_browser_panel) ->

    @windows = $.map(@embedded_browser_panel.find(".embedded-browser-window"), (value, index) ->
      new EmbeddedBrowserWindow($(value)))
    @init_search_field()
    @init_search_button()
    @init_collapse_results_button()
    @embedded_browser_panel.find(".loading-indicator").hide()

  init_search_field: () ->
    default_term = $(".searchable-term:first").val()
    $(".search-input:first").val(default_term)

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
    @init_get_text_button()

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
        if $(empty_image_fields).size() > 0
          $(empty_image_fields[0]).val(page.url)
          Util.show_flash("Added citation")
        else
          Util.show_flash("No more citation slots, save activity and reopen", 2)

  init_get_text_button: () =>
    button = @embedded_browser_window_panel.find(".browser-get-text-button")
    button.attr("disabled", true)
    button.click =>
      selected = window.getSelection().toString()
      # binding to the form_tag_generated id, underscores not dashes
      instructions = $("#activity_instructions").text()
      if instructions == "None"
        Util.show_flash("Added text to instructions")
        $("#activity_instructions").text(selected)
      else
        Util.show_flash("Appended text to instructions")
        $("#activity_instructions").text(instructions + "\n" + selected)

  render: () =>
    page = @pages[@pages.length - 1]
    @embedded_browser_window_panel.find(".browser-back-button").attr("disabled", @pages.length <= 1);
    @embedded_browser_window_panel.find(".browser-bookmark-button").attr("disabled", @pages.length <= 1);
    @embedded_browser_window_panel.find(".browser-get-text-button").attr("disabled", @pages.length <= 1);
    try
      @embedded_browser_window_panel.find(".proxied-page-contents").html(page.contents)
    catch error
    try
      page_contents = @embedded_browser_window_panel.find(".proxied-page-contents")
      @rewrite_link_event_handlers(page_contents)
      @init_video_links(page_contents)
      @init_image_links(page_contents)
      @init_keyword_links(page_contents)
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
      if $(a_tag).find(".keyword-match").size() > 0
        $(a_tag).click(-> false) # turn off links that contain clickable keywords
      else
        fetcher = new URLFetcher(this, $(a_tag).attr("href"))
        $(a_tag).click (e)=>
          fetcher.go()
          false
    )

  init_keyword_links: (page_contents)=>
    $(page_contents).find(".keyword-match .add-keyword").click ->
      identifier = $(this).parent().attr("identifier")
      unless $("#activity-builder-" + identifier).is(":checked")
        Util.show_flash("Added " + $(this).parent().text(), 1)
        $("#activity-builder-" + identifier).click()
      else
        Util.show_flash("Already added " + $(this).parent().text(), 1)

  init_video_links: (page_contents)=>
    $(page_contents).find(".video-wrapper button").click ->
      link = $(this).siblings("a:first").attr("href")
      if $("#activity-video-link").size() > 0
        Util.show_flash("Added video link", 1)
        $("#activity-video-link").val(link)

  init_image_links: (page_contents)=>
    $(page_contents).find(".image-wrapper button").click ->
      link = $(this).siblings("a:first").attr("href") or $(this).siblings("img:first").attr("src")
      empty_image_fields = $(".image-url-input").filter ->
        this.value == ""
      if $(empty_image_fields).size() > 0
        Util.show_flash("Added image link", 1)
        $(empty_image_fields[0]).val(link)
      else
        Util.show_flash("No more image slots, save activity and reopen", 2)

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