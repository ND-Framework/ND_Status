enableUI = true
config = {
    {
        type = "hunger",
        enabled = true,
        max = 100.0,
        decreaseRate = 0.1,
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
        decreaseRate = 0.1,
        style = {
            circleColor = "#428af5",
            iconColor = "#ffffff",
            icon = "fa-solid fa-bottle-water",
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
        style = {
            circleColor = "#2eb03b",
            iconColor = "#ffffff",
            icon = "fa-solid fa-person-running",
        }
    },
}