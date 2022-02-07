import dayjs from 'dayjs'
import customParseFormat from 'dayjs/plugin/customParseFormat.js'

dayjs.extend customParseFormat

export date=null
export name=null

displayDate = dayjs(date).format 'ddd MMM D'
