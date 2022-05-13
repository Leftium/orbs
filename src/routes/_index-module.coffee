import dayjs from 'dayjs'
import customParseFormat from 'dayjs/plugin/customParseFormat.js'

dayjs.extend customParseFormat

DEFAULT_SOURCE_URL = 'https://www.reddit.com/r/FireEmblemHeroes/comments/un54ed'

sourceUrlRE = ///https://www.reddit.com/r/FireEmblemHeroes/comments/([^/]+).*///
orbLineRE = /^\D{3} ((\D{3})\D* (\d{1,2})): (\d+) orb/
bannerLineRE = /^\*\s+(\d{4}-\d{2}-\d{2}):? (.*)/

_load = ({ url, params, props, fetch, session, stuff }) ->
    sourceUrl = url.searchParams.get('u') or DEFAULT_SOURCE_URL
    if slug = url.searchParams.get 's'
        sourceUrl = "https://www.reddit.com/r/FireEmblemHeroes/comments/#{slug}"
    origin = url.origin
    markdownUrl="#{origin}/api/r2md/#{sourceUrl}"

    matches = sourceUrl.match sourceUrlRE
    slug = slug or matches?[1]

    # First try local cache.
    response = await fetch "/txt/#{slug}.md"
    if response.status is 200
        console.log "CACHED: /txt/#{slug}.md"
        markdown = await response.text()
    else
        console.log "FETCH: #{markdownUrl}"
        response = await fetch markdownUrl
        markdown = await response.text()

    lines = markdown.split '\n'

    matches = lines[0].match /(\d{4})-(\d{2})/


    now = dayjs()
    year = (parseInt matches?[1]) or now.year()
    month = (parseInt matches?[2]) or (now.month() + 1)

    lastCompleteJan = if month is 1 then year-1 else year

    total = 0
    orbs = []
    banners = []
    calendarData = []
    for line in lines
        if matches = line.match orbLineRE
            [_, _, month, date, count] = matches

            count = parseInt count, 10
            total += count

            if (month is 'Jan') and (year is lastCompleteJan)
                year++

            if (month isnt 'Jan') and (year isnt lastCompleteJan)
                lastCompleteJan++

            fulldate = "#{month} #{date} #{year}"

            theDayjs = dayjs(fulldate, 'MMM D YYYY')

            fulldate = theDayjs.format 'YYYY-MM-DD'

            orbs.push item =
                x: fulldate
                y: count

            day = theDayjs.day()

            calendarData.push item =
                day:   day
                month: month
                date:  date
                year:  year
                count: count
                total: total

        if matches = line.match bannerLineRE
            [_, date, name] = matches

            banners.push { date, name }

        generateCalendar = (data) ->
            ```
            let output = ''
            let week = [];

            function generateWeek(week) {
                output += '|';
                    for (let i=0; i<7; i++) {
                        let d = week[i] || '';
                        output += d + '|';
                    }
                    output += '\n';
            }

            let prevMonth = ''
            for (let item of data) {
                let { day, month, date, year, count, total } = item;

                if (prevMonth != month) {
                    output += `\n**${month} ${year}**\n\n`
                    output += '|*Sun*|*Mon*|*Tue*|*Wed*|*Thu*|*Fri*|*Sat*|\n'
                    output += '|-:|-:|-:|-:|-:|-:|-:|\n'
                    prevMonth = month;
                }

                week[day] = `${total} **^(${date})**`


                if (day == 6) {
                    generateWeek(week);
                    week = [];
                }
            }
            if (week.length) {
                generateWeek(week);
            }
            ```
            output

    calendar = generateCalendar(calendarData)
    data = {orbs, banners, calendar}

    return output =
        props: { data, sourceUrl, origin }

`export const load = _load`
