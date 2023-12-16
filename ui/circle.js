const template = document.createElement("template");
template.innerHTML = `
<style>
    .circle {
        position: relative;
        width: 2vw;
        height: 2vw;
        border-radius: 50%;

        display: flex;
        justify-content: center;
        align-items: center;

        background: conic-gradient(
            from 0deg,
            var(--circleColor) 0%,
            var(--circleColor) 0% var(--value),
            #3b3b3b var(--value),
            #3b3b3b 100%
        );
        
        transition: background 0.5s ease;
    }

    .info {
        display: flex;
        justify-content: center;
        align-items: center;

        width: 80%;
        height: 80%;
        background-color: #333;
        border-radius: 50%;
    }

    .icon {
        color: var(--iconColor);
    }
</style>

<div class="circle">
    <div class="info">
        <i class="icon"></i>
    </div>
</div>
`



class circle extends HTMLElement {
    constructor() {
        super();
        const shadow = this.attachShadow({ mode: "open" });
        const templateContent = template.content.cloneNode(true);
        shadow.append(templateContent);

        const fontAwesomeLink = document.createElement("link");
        fontAwesomeLink.setAttribute("rel", "stylesheet");
        fontAwesomeLink.setAttribute("href", "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css");
        shadow.appendChild(fontAwesomeLink);
    }

    static get observedAttributes() {
        return ["circleColor", "iconColor", "icon", "value"];
    }

    attributeChangedCallback(name, oldValue, newValue) {
        this[name] = newValue;
        this.render();
    }

    connectedCallback() {
        this.circleColor = this.getAttribute("circle-color");
        this.iconColor = this.getAttribute("icon-color");
        this.icon = this.getAttribute("icon");
        this.value = this.getAttribute("value");
        this.render();
    }

    render() {
        if (!this.circleColor || !this.iconColor || !this.icon || !this.value) {return}
        const shadow = this.shadowRoot;
        const circleElement = shadow.querySelector(".circle");

        if (circleElement) {
            circleElement.style.setProperty("--circleColor", this.circleColor);
            circleElement.style.setProperty("--value", `${this.value}%`);
        }

        const iconElement = shadow.querySelector(".icon");
        if (iconElement) {
            iconElement.style.setProperty("--iconColor", this.iconColor);

            const classesArray = this.icon.split(" ");
            classesArray.forEach(className => {
                iconElement.classList.add(className);
            });
        }
    }
}

customElements.define("status-circle", circle);
