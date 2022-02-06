url = 'https://www.reddit.com/r/FireEmblemHeroes/comments/s19x8o/'

_load = ({ params, fetch, session, stuff }) ->
    response = await fetch url
    text = await response.text()

    return output =
        props:
            text: text

`export const load = _load`
