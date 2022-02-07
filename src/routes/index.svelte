<script context=module src='./_index-module.coffee'></script>
<script src='./_index.coffee'></script>

<div class=chart>
    <canvas bind:this={canvas} width="400" height="400"></canvas>
</div>

<div>
    <label>
        Initial Orbs
        <input
            type=number
            inputmode='decimal'
            bind:value={initialOrbs}
            on:change={handleChange} />
    </label>
</div>
<div class='banners'>
    {#each data.banners as banner}
        <Banner
            date={banner.date}
            name={banner.name}
        />
    {/each}
</div>


<style>
    input::-webkit-outer-spin-button,
    input::-webkit-inner-spin-button {
      -webkit-appearance: none;
      margin: 0;
    }

    /* Firefox */
    input[type=number] {
      -moz-appearance: textfield;
    }

    label {
      display: block;
    }

    .chart {
        position: relative;
        margin: auto;
        height: 80vh;
    }
</style>

