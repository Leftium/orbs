<script context=module src='./_index-module.coffee'></script>
<script src='./_index.coffee'></script>


{data.url}

<canvas bind:this={canvas} width="400" height="400"></canvas>

<pre>
    {JSON.stringify(data.banners, null, 4)}
</pre>
<pre>
    {JSON.stringify(data.orbs, null, 4)}
</pre>

