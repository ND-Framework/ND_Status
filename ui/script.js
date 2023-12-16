let statusUI = {}

const actions = {
    remove: function() {
        $(".info").empty()
        statusUI = {}
    },

    add: function(item) {
        const info = item.info;
        statusUI[info.type] = "shown"
        $(".info").append(`
            <status-circle id="circle-${info.type}"
                circle-color="${info?.style?.circleColor || "white"}"
                icon-color="${info?.style?.iconColor || "white"}"
                icon="${info?.style?.icon}"
                value="100"
            ></status-circle>
        `);
    },
    
    update: function(item) {
        for (const [_, value] of Object.entries(JSON.parse(item.info))) {
            let newValue = value.max/value.status;
            let newValue2 = value.status/newValue;
            const element = $(`#circle-${value.type}`);
            element.attr("value", newValue2);

            if (newValue2 > 90 && statusUI[value.type] == "shown") {
                statusUI[value.type] = "hidden";
                element.fadeOut();
            } else if (newValue2 < 90 && statusUI[value.type] == "hidden") {
                statusUI[value.type] = "shown";
                element.fadeIn();
            };
        };
    }
}

window.addEventListener("message", function(event) {
    const item = event.data;
    const action = actions[item.type]
    if (action) {
        action(item)
    }
});
