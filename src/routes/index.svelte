<script context=module src='./_index-module.coffee'></script>
<script src='./_index.coffee'></script>

<!-- svelte-ignore a11y-label-has-associated-control -->
<div class=source-url>
    <label>
        <div>
            <span>FEH Orb Planner</span>
            Source: <a href={sourceUrl}>r/FireEmblemHeroes</a> |
            Markdown: <a href={markdownUrl+'?dl=0' } rel=external>view</a>
            <a href={markdownUrl+'?dl=1'} rel=external>download</a> |
            <a href="https://www.reddit.com/r/FireEmblemHeroes/search?q=%22Estimate%20of%20upcoming%20orbs%22&restrict_sr=1&sort=new">More Orb Estimates</a>

        <div>
        <input
            bind:value={targetUrl}
            on:focus={selectOnFocus}
            on:keydown={handleKeyDown}
        />
    </label>
</div>


<div class=chart>
    <canvas bind:this={canvas} width="400" height="400"></canvas>
</div>

<!-- svelte-ignore a11y-label-has-associated-control -->
<div class=initial-orbs>
    <label>
        <div><span>My Initial Orbs</span><div>
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
            updateBannerOrbsUsed={updateBannerOrbsUsed}
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

    .initial-orbs,
    .source-url{
        font-family: sans-serif;
        margin-left: 105px;
        margin-bottom: 20px;
    }

    .source-url input {
        width: 80%;
    }
    span {
        font-size: 120%;
        font-weight: 700;
    }
    input {
        padding: 5px 11px;
        width: 294px;
    }

    .chart {
        position: relative;
        margin: auto;
        height: 80vh;
    }

    .banners {
        margin-bottom: 240px;
    }
</style>

