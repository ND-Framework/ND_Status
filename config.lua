enableUI = true
config = {
    {
        type = "hunger",
        enabled = true,
        max = 100.0,
        decreaseRate = 1.2,
        action = "starve",
        style = {
            circleColor = "#ff8a14",
            iconColor = "#ffffff",
            icon = "fa-solid fa-burger",
        }
    },
    {
        type = "thirst",
        enabled = true,
        max = 100.0,
        decreaseRate = 1.0,
        action = "starve",
        style = {
            circleColor = "#428af5",
            iconColor = "#ffffff",
            icon = "fa-solid fa-glass-water",
        }
    },
    {
        type = "alcohol",
        enabled = true,
        max = 100.0,
        decreaseRate = 1.0,
        reversed = true,
        default = 0,
        action = "alcohol",
        style = {
            circleColor = "#a032a8",
            iconColor = "#ffffff",
            icon = "fa-solid fa-wine-glass",
        }
    },
    {
        type = "stamina",
        enabled = true,
        max = 100.0,
        increaseRate = 1.0,
        onRun = 0.5,
        onSprint = 2.0,
        onJump = 3.0,
        action = "stamina",
        style = {
            circleColor = "#2eb03b",
            iconColor = "#ffffff",
            icon = "fa-solid fa-person-running",
        }
    },
    {
        type = "health",
        enabled = true,
        max = 100.0,
        action = "health",
        style = {
            circleColor = "#e44949",
            iconColor = "#ffffff",
            icon = "fa-solid fa-heart",
        }
    },
    {
        type = "armor",
        enabled = true,
        max = 100.0,
        reversed = true,
        default = 0,
        action = "armor",
        style = {
            circleColor = "#1ab2ff",
            iconColor = "#ffffff",
            icon = "fa-solid fa-shield-halved",
        }
    },
}
