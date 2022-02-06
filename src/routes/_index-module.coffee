targetUrl = 'https://www.reddit.com/r/FireEmblemHeroes/comments/s19x8o'

_load = ({ url, params, props, fetch, session, stuff }) ->
    response = await fetch "#{url.origin}/api/r2md/#{targetUrl}"
    data     = await response.json()

    return output =
        props: { data }

`export const load = _load`
