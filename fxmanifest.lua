-- For support join my discord: https://discord.gg/Z9Mxu72zZ6

author "Andyyy#7666"
description "Status for ND"
version "1.0.0"

fx_version "cerulean"
game "gta5"
lua54 "yes"

files {
    "source/index.html",
    "source/style.css",
    "source/script.js"
}
ui_page "source/index.html"

shared_script "config.lua"
server_scripts {
    "source/server.lua"
}
client_scripts {
    "source/client.lua"
}

exports {
    "setStats",
    "changeStatus",
    "setMaxStatus",
    "getStatus"
}