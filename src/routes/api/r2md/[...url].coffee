export get = ({request, url, params, locals, platform}) ->
    return output =
        status: 200
        body: params
