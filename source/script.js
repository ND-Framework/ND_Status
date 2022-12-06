$(function() {
    let statusUI = {};

    window.addEventListener("message", function(event) {
        const item = event.data;

        if (item.type == "remove") {
            $(".info").empty();
        };
        
        if (item.type == "add") {
            statusUI[item.info.type] = "shown";
            $(".info").append(`
                <div class="container" id="circle${item.info.type}" style="background-color: ${item.info.style.circleColor};">
                    <i class="${item.info.style.icon} icon" style="color: ${item.info.style.iconColor};"></i>
                    <div class="fill" id="${item.info.type}" style="background-color: ${item.info.style.circleColor};"></div>
                </div>
            `);
        };


        if (item.type == "update") {
            for (const [_, value] of Object.entries(JSON.parse(item.info))) {
                let newValue = value.max/value.status;
                let newValue2 = value.status/newValue;
                $(`#${value.type}`).css("height", `${newValue2}%`);

                if (newValue2 > 90 && statusUI[value.type] == "shown") {
                    statusUI[value.type] = "hidden";
                    $(`#circle${value.type}`).fadeOut();
                } else if (newValue2 < 90 && statusUI[value.type] == "hidden") {
                    statusUI[value.type] = "shown";
                    $(`#circle${value.type}`).fadeIn();
                };
            };
        };

    });
});