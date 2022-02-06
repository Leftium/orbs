<script context=module src='./_index-module.coffee'></script>
<script src='./_index.coffee'></script>

<canvas bind:this={canvas} width="400" height="400"></canvas>

<label>
    Initial Orbs
    <input
        type=number
        inputmode='decimal'
        bind:value={initialOrbs}
        on:change={handleChange} />
</label>

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
</style>


