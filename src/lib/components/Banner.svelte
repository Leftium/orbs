<script context="module">
    let count = 0
</script>


<script src='./banner.coffee'></script>

<div class=main>
    <label>
        <div>
            <span class=date>{displayDate}</span>
            <span class=name>{name}</span>
        </div>
        <div class=input-wrapper class:hideDropdown>
            <AutoComplete
                items={suggestions}
                bind:selectedItem={selectedOption}
                noResultsText=''
                hideArrow=true
                onFocus={handleFocus}
                onBlur={handleBlur}
                inputClassName='input-element'
                inputId={id}
            />
        </div>
    </label>
</div>

<style>
    div {
        font-family: sans-serif;
    }

    .main {
        margin-bottom: 20px;
    }

    label {
      display: block;
    }

    .date {
        display: inline-block;
        width: 100px;
        color: #ccc;
        font-weight: 600;
        text-align: right;
    }

    .name {
        font-size: 120%;
        font-weight: 700;
    }
    .input-wrapper {
        margin-left: 105px;
    }
    :global(.input-element) {
        width: 320px !important;
    }

    .hideDropdown :global(.autocomplete-list) {
        display: none;
    }
</style>

