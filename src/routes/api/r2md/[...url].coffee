import * as cheerio from 'cheerio'

import TurndownService from 'turndown'
turndownService = new TurndownService()

export get = ({request, url, params, locals, platform}) ->
    response = await fetch params.url
    html = await response.text()

    $ = cheerio.load html
    html = $('div[data-click-id="text"]').html()  # Isolate main post.

    markdown = turndownService.turndown html      # Convert to markdown.

    return output =
        status: 200
        body:
            url: params.url
            markdown: markdown

