import * as cheerio from 'cheerio'
import TurndownService from 'turndown'

turndownService = new TurndownService()
url = 'https://www.reddit.com/r/FireEmblemHeroes/comments/s19x8o/'

_load = ({ params, fetch, session, stuff }) ->
    response = await fetch url
    html = await response.text()

    $ = cheerio.load html
    html = $('div[data-click-id="text"]').html()  # Isolate main post.

    text = turndownService.turndown html          # Convert to markdown.

    return output =
        props:
            text: text

`export const load = _load`
