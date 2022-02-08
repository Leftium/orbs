export get = ({request, url, params, locals, platform}) ->

    body = {request, url, params, locals, platform}

    return output =
        status: 200
        body: body

