import { DateTime } from 'luxon'

import Chart from 'chart.js/auto/auto.esm'
import 'chartjs-adapter-luxon'

import { onMount } from 'svelte'

export data=null  # Prop passed from load().

export canvas = null

sum = 0
cumulativeOrbs = []
for orb in data.orbs
    sum += orb.y
    cumulativeOrbs.push item =
        x: orb.x
        y: sum




onMount () ->
    chart = new Chart canvas, options =
         type: 'line'
         data:
            datasets: [{
                label: 'Orbs',
                data: cumulativeOrbs,
                fill: true,
                borderColor: 'rgb(75, 192, 192)',
            }]
         options:
            animation: false
            scales:
                x:
                    type: 'time'
                    time:
                        tooltipFormat: 'MMM d'
                        title:
                            display: true
                            text: 'Date'

