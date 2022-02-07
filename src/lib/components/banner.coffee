import dayjs from 'dayjs'
import customParseFormat from 'dayjs/plugin/customParseFormat.js'

dayjs.extend customParseFormat

import { onMount } from 'svelte'

import AutoComplete from "simple-svelte-autocomplete"

export date=null
export name=null

inputElement=null

id = "banner-#{count++}"


# State variables for workaround to hide dropdown
# https://github.com/pstanoev/simple-svelte-autocomplete/issues/126#issue-1097042607 
mousedown=false
hideDropdown=false


onMount () ->
    document.addEventListener 'mousedown', () -> mousedown = true
    document.addEventListener 'mouseup',   () -> mousedown = false
    inputElement = document.getElementById id


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

handleFocus = (e) ->
    hideDropdown = false
    inputElement.select()

handleBlur  = (e) -> if not mousedown then hideDropdown = true

