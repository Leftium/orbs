import { DateTime } from 'luxon'

import Chart from 'chart.js/auto/auto.esm'
import 'chartjs-adapter-luxon'

import annotationPlugin from 'chartjs-plugin-annotation'
Chart.register annotationPlugin

import { onMount } from 'svelte'

export data=null  # Prop passed from load().

export canvas = null

chart = null

initialOrbs = 300



calculateChartData = () ->
    cumulativeOrbs = []
    netOrbs = []

    sum = 0
    currentOrbs = initialOrbs
    for orb in data.orbs
        sum += orb.y
        cumulativeOrbs.push item =
            x: orb.x
            y: sum

        netOrbs.push item =
            x: orb.x
            y: currentOrbs + sum

        currentOrbs -= 21

    {cumulativeOrbs, netOrbs}


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

handleChange = (e) ->
    {cumulativeOrbs, netOrbs} = calculateChartData()

    chart.data.datasets[0].data = cumulativeOrbs
    chart.data.datasets[1].data = netOrbs

    chart.update()

onMount () ->
    {cumulativeOrbs, netOrbs} = calculateChartData()
    chart = new Chart canvas, options =
         type: 'line'
         data:
            datasets: [{
                label: 'Orb Income',
                data: cumulativeOrbs,
                borderColor: 'rgb(38,139,210)',
                fill:
                    target: 'origin'
                    above: 'rgb(38,139,210,0.1)'
            }, {
                label: 'Net Orbs',
                data: netOrbs,
                borderColor: 'rgb(220,50,47)',
                fill:
                    target: 'origin'
                    above: 'rgb(220,50,47,0.1)'
                    below: 'rgba(0,0,0,0)'
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

