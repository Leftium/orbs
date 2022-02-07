import * as cheerio from 'cheerio'

import TurndownService from 'turndown'
turndownService = new TurndownService()

sourceUrlRE = ///https://www.reddit.com/r/FireEmblemHeroes/comments/([^/]+).*///

export get = ({request, url, params, locals, platform}) ->

    matches = url.pathname.match sourceUrlRE

    slug = matches[1] or 'filename'

    filename = "#{slug}.md"

    response = await fetch params.url
    html = await response.text()

    $ = cheerio.load html

    title = $('h1:first').text()                  # Get title.

    html = $('div[data-click-id="text"]').html()  # Isolate main post.

    markdown = turndownService.turndown html      # Convert to markdown.

    markdown = "# #{title}\n\n#{markdown}"

    headers =
        'Content-Disposition': "attachment; filename=#{filename}"

    return output =
        status: 200
        headers: headers
        body: markdown

