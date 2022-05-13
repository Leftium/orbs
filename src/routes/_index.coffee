import {Chart, registerables} from 'chart.js/dist/chart.esm'
Chart.register ...registerables

import 'chartjs-adapter-luxon'

import {Tooltip} from 'chart.js/dist/chart.esm'
Tooltip.positioners.topPositioner = (elements, eventPosition) ->
    result =
        x: elements[0]?.element.x
        y: 0

import Banner from '$lib/components/Banner.svelte'

import annotationPlugin from 'chartjs-plugin-annotation'
Chart.register annotationPlugin

import { onMount } from 'svelte'

# Props passed from load().
export data=null
export origin=null
export sourceUrl=null
export targetUrl=sourceUrl

```$: {```
markdownUrl="#{origin}/api/r2md/#{sourceUrl}"
calendarUrl="#{origin}/calendar/?u=#{sourceUrl}"
```}```

export canvas=null
chart=null




orbUseByBanner = {}
orbUseByDate = {}
initialOrbs = 300

calculateChartData = () ->
    estimatedOrbs = []
    netOrbs = []

    orbUseByDate = {}
    for id,use of orbUseByBanner
        count = parseInt use.orbs, 10

        orbUseByDate[use.date] = orbUseByDate[use.date] or 0
        orbUseByDate[use.date] = orbUseByDate[use.date] + count

    sum = 0
    sumUsed = 0
    currentOrbs = initialOrbs
    for orb in data.orbs
        sum += orb.y
        sumUsed += (orbUseByDate[orb.x] or 0)

        estimatedOrbs.push item =
            x: orb.x
            y: sum

        netOrbs.push item =
            x: orb.x
            y: currentOrbs + sum - sumUsed

    {estimatedOrbs, netOrbs}


updateBannerOrbsUsed = (id, date, orbs) ->
    orbUseByBanner[id] = { date, orbs }
    calculateChartData()
    handleChange()

makeAnnotation = (date, content, color='152,78,163', adjust=true, position='end') ->
    annotation =
        type: 'line'
        scaleID: 'x'
        borderWidth: 2
        borderColor: "rgba(#{color},0.4)"
        drawTime: 'beforeDatasetsDraw'
        value: date
        adjustScaleRange: adjust
        label:
            content: content
            color: "rgba(#{color},1)"
            backgroundColor: 'rgba(0, 0, 0, 0)'
            font:
                size: 15
                style: 'normal'
            position: position
            rotation: 270
            xAdjust: 11
            enabled: true

annotations = []

annotations.push makeAnnotation new Date(), 'Today', '0,0,0', false, 'start'

label = ''
for banner,i in data.banners
    label += " | #{banner.name.replace /:.*/, ''}"
    if banner.date isnt data.banners[i+1]?.date
        if label.length > 40
            label = label[0..40] + '...'
        annotations.push makeAnnotation banner.date, label[3..]
        label = ''

handleChange = (e) ->
    {estimatedOrbs, netOrbs} = calculateChartData()

    if chart
        chart.data.datasets[0].data = netOrbs
        chart.data.datasets[1].data = estimatedOrbs

        chart.update()

handleKeyDown = (e) ->
    if e.code is 'Enter'
        url = "/?u=#{@value}"
        document.location = url


selectOnFocus = (e) ->
    @select()

onMount () ->
    {estimatedOrbs, netOrbs} = calculateChartData()

    chart = new Chart canvas, options =
         type: 'line'
         data:
            datasets: [{
                label: 'My Orbs'
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
                data: estimatedOrbs
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
                        unit: 'day'
                        tooltipFormat: 'MMM d'
                        title:
                            display: true
                            text: 'Date'

