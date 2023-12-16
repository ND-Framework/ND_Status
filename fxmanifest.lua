-- For support join my discord: https://discord.gg/Z9Mxu72zZ6

author "Andyyy#7666"
description "Status for ND"
version "1.0.0"

fx_version "cerulean"
game "gta5"
lua54 "yes"

files {
    "ui/style.css",
    "ui/script.js",
    "ui/circle.js",
    "ui/index.html"
}
ui_page "ui/index.html"

shared_scripts {
    "config.lua",
    "@ND_Core/init.lua"
}
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