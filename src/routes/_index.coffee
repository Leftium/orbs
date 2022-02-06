import { DateTime } from 'luxon'

import Chart from 'chart.js/auto/auto.esm'
import 'chartjs-adapter-luxon'

import annotationPlugin from 'chartjs-plugin-annotation'
Chart.register annotationPlugin

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


makeAnnotation = (date, content) ->
    annotation =
        type: 'line'
        scaleID: 'x'
        borderWidth: 2
        borderColor: 'rgba(0, 128, 0, 0.4)'
        value: date
        label:
            content: content
            color: 'rgba(0, 128, 0, 1)'
            backgroundColor: 'rgba(0, 0, 0, 0)'
            font:
                size: 15
                style: 'normal'
            position: 'end'
            rotation: 270
            xAdjust: 12
            enabled: true

annotations = []
label = ''
for banner,i in data.banners
    label += " | #{banner.name.replace /:.*/, ''}"
    if banner.date isnt data.banners[i+1]?.date
        annotations.push makeAnnotation banner.date, label[2..]
        label = ''

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
            plugins:
                 annotation: {annotations}
            animation: false
            scales:
                x:
                    type: 'time'
                    time:
                        tooltipFormat: 'MMM d'
                        title:
                            display: true
                            text: 'Date'

