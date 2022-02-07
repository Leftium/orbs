import dayjs from 'dayjs'
import customParseFormat from 'dayjs/plugin/customParseFormat.js'

dayjs.extend customParseFormat

DEFAULT_SOURCE_URL = 'https://www.reddit.com/r/FireEmblemHeroes/comments/s19x8o'

sourceUrlRE = ///https://www.reddit.com/r/FireEmblemHeroes/comments/([^/]+).*///
orbLineRE = /^\D{3} (\D{3} \d{1,2}): (\d+) orb/
bannerLineRE = /^\*\s+(\d{4}-\d{2}-\d{2}): (.*)/

_load = ({ url, params, props, fetch, session, stuff }) ->
    sourceUrl = url.searchParams.get('u') or DEFAULT_SOURCE_URL

    matches = sourceUrl.match sourceUrlRE
    slug = matches[1]

    # First try local cache.
    response = await fetch "/txt/#{slug}.md"
    if response.status is 200
        markdown = await response.text()
    else
        console.log "FETCH: #{sourceUrl}"
        response = await fetch "#{url.origin}/api/r2md/#{sourceUrl}"
        markdown = await response.text()

    lines = markdown.split '\n'

    orbs = []
    banners = []
    for line in lines
        if matches = line.match orbLineRE
            [_, date, count] = matches
            count = parseInt count, 10

            date = dayjs(date, 'MMM D').format 'YYYY-MM-DD'

            orbs.push item =
                x: date
                y: count

        if matches = line.match bannerLineRE
            [_, date, name] = matches

            banners.push { date, name }

    data = {orbs, banners}

    return output =
        props: { data, sourceUrl }

`export const load = _load`
