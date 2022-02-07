import dayjs from 'dayjs'
import customParseFormat from 'dayjs/plugin/customParseFormat.js'

dayjs.extend customParseFormat

import {plainText as txt} from '$lib/txt/s19x8o.md'

DEFAULT_SOURCE_URL = 'https://www.reddit.com/r/FireEmblemHeroes/comments/s19x8o'

orbLineRE = /^\D{3} (\D{3} \d{1,2}): (\d+) orb/
bannerLineRE = /^\*\s+(\d{4}-\d{2}-\d{2}): (.*)/

_load = ({ url, params, props, fetch, session, stuff }) ->
    if url.searchParams.get('mock') is '1'
        markdown = txt
        sourceUrl = DEFAULT_SOURCE_URL
    else
        sourceUrl = url.searchParams.get('u') or DEFAULT_SOURCE_URL
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
