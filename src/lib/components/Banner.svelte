<script src='./banner.coffee'></script>

<div class=main>
    <label>
        <div>
            <span class=date>{displayDate}</span>
            <span class=name>{name}</span>
        </div>
        <input
            data-date='{date}'
            value=10
        />
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
    input {
        margin-left: 105px;
    }

</style>

