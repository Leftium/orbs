import dayjs from 'dayjs'
import customParseFormat from 'dayjs/plugin/customParseFormat.js'

dayjs.extend customParseFormat

import { onMount } from 'svelte'

import AutoComplete from "simple-svelte-autocomplete"

export date=null
export name=null
export text=null
export updateBannerOrbsUsed=null

inputElement=null

id = "banner-#{count++}"


# State variables for workaround to hide dropdown
# https://github.com/pstanoev/simple-svelte-autocomplete/issues/126#issue-1097042607 
mousedown=false
hideDropdown=false


suggestions = [
    '0 (none)'
    '155 (spark: full circles)'
    '195 (spark: snipe)'
    '135 (spark: 4 tickets, full circles)'
    '175 (spark: 4 tickets, snipe)'
    '140 (spark: 3 tickets, full circles)'
    '180 (spark: 3 tickets, snipe)'
]
selectedOption=suggestions[0]

displayDate = dayjs(date).format 'ddd MMM D'

handleFocus = () ->
    hideDropdown = false
    inputElement.select()

handleBlur  = () ->
    if not mousedown then hideDropdown = true
    updateBannerOrbsUsed id, date, text

handleChange = () ->
    updateBannerOrbsUsed id, date, text

handleCreate = (newItem) ->
    suggestions.unshift newItem
    suggestions = suggestions
    updateBannerOrbsUsed id, date, text
    return newItem

onMount () ->
    document.addEventListener 'mousedown', () -> mousedown = true
    document.addEventListener 'mouseup',   () -> mousedown = false
    inputElement = document.getElementById id

    updateBannerOrbsUsed id, date, text
