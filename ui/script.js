let statusUI = {}

const actions = {
    remove: function() {
        $(".info").empty()
        statusUI = {}
    },

    add: function(item) {
        const info = item.info;
        statusUI[info.type] = "hidden"
        $(".info").prepend(`
            <status-circle id="circle-${info.type}" style="display: none;"
                circle-color="${info?.style?.circleColor || "white"}"
                icon-color="${info?.style?.iconColor || "white"}"
                icon="${info?.style?.icon}"
                value="100"
            ></status-circle>
        `);
    },
    
    update: function(item) {
        for (const [_, value] of Object.entries(JSON.parse(item.info))) {
            if (statusUI[value.type] && typeof(value.status) == "number") {
                let newValue = value.status;
                const element = $(`#circle-${value.type}`);
                element.attr("value", newValue);
    
                const reversed = value.reversed
                if ((!reversed && newValue > 99 || reversed && newValue < 1) && statusUI[value.type] == "shown") {
                    statusUI[value.type] = "hidden";
                    element.fadeOut();
                } else if ((!reversed && newValue < 99 || reversed && newValue > 1) && statusUI[value.type] == "hidden") {
                    statusUI[value.type] = "shown";
                    element.fadeIn();
                };
            }
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
