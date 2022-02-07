import { DateTime } from 'luxon'

import Chart from 'chart.js/auto/auto.esm'
import 'chartjs-adapter-luxon'

import { Tooltip } from 'chart.js'
Tooltip.positioners.topPositioner = (elements, eventPosition) ->
    result =
        x: elements[0]?.element.x
        y: eventPosition.y

import Banner from '$lib/components/Banner.svelte'

import annotationPlugin from 'chartjs-plugin-annotation'
Chart.register annotationPlugin

import { onMount } from 'svelte'

export data=null  # Prop passed from load().

export canvas=null
chart=null


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

        currentOrbs -= 20

    {cumulativeOrbs, netOrbs}


makeAnnotation = (date, content) ->
    annotation =
        type: 'line'
        scaleID: 'x'
        borderWidth: 2
        borderColor: 'rgba(152,78,163,0.4)'
        drawTime: 'beforeDatasetsDraw'
        value: date
        label:
            content: content
            color: 'rgba(152,78,163,1)'
            backgroundColor: 'rgba(0, 0, 0, 0)'
            font:
                size: 15
                style: 'normal'
            position: 'end'
            rotation: 270
            xAdjust: 11
            enabled: true

annotations = []
label = ''
for banner,i in data.banners
    label += " | #{banner.name.replace /:.*/, ''}"
    if banner.date isnt data.banners[i+1]?.date
        if label.length > 40
            label = label[0..40] + '...'
        annotations.push makeAnnotation banner.date, label[2..]
        label = ''

handleChange = (e) ->
    {cumulativeOrbs, netOrbs} = calculateChartData()

    chart.data.datasets[0].data = netOrbs
    chart.data.datasets[1].data = cumulativeOrbs

    chart.update()

onMount () ->
    {cumulativeOrbs, netOrbs} = calculateChartData()

    chart = new Chart canvas, options =
         type: 'line'
         data:
            datasets: [{
                label: 'Net Orbs'
                data: netOrbs
                borderColor: 'rgb(55,126,184)'
                backgroundColor: 'rgb(55,126,184)'
                borderWidth: 9
                pointBorderColor: 'rgba(0,0,0,0)'
                pointRadius: 0
                tension: 0.2
                fill:
                    target: 'origin'
                    above: 'rgb(55,126,184,0.1)'
                    below: 'rgba(220,50,47,0.1)'
            },{
                label: 'Orb Income'
                data: cumulativeOrbs
                borderColor: 'rgb(77,175,74)'
                backgroundColor: 'rgb(77,175,74)'
                borderWidth: 5
                pointBorderColor: 'rgba(0,0,0,0)'
                pointRadius: 0
                tension: 0.2
                fill:
                    target: 'origin'
                    above: 'rgb(77,175,74,0.1)'
            }]
         options:
            responsive: true
            maintainAspectRatio: false
            plugins:
                 annotation: {annotations}
                 legend:
                     position: 'bottom'
                 tooltip:
                    mode: 'index'
                    intersect: false
                    position: 'topPositioner'
            animation: false
            scales:
                x:
                    type: 'time'
                    time:
                        tooltipFormat: 'MMM d'
                        title:
                            display: true
                            text: 'Date'

