const clamp = (value: number, min: number, max: number): number => {
    const a = Math.max(value, min);
    return Math.min(a, max);
}

class BrightnessService extends Service {
    static {
        Service.register(
            this,
            // Signals
            {
                "percent-changed": ["float"],
            },
            // Properties
            {
                "percent": ["float", "rw"],
            }
        )
    }

    #interface: string = Utils.exec("brightnessctl info -m").split(",")[0];

    /** The brightness percent from 0 to 1 */
    #percent: number = 0;
    #max: number = Number(Utils.exec("brightnessctl max"));

    get percent() {
        return this.#percent;
    }

    set percent(percent: number) {
        percent = clamp(percent, 0, 1) * 100;

        Utils.execAsync(`brightnessctl set ${percent}% --quiet`);
    }

    constructor() {
        super();

        const brightnessPath = `/sys/class/backlight/${this.#interface}/brightness`;
        Utils.monitorFile(brightnessPath, () => this.#onChange());

        this.#onChange();
    }

    #onChange() {
        this.#percent = Number(Utils.exec("brightnessctl get")) / this.#max;

        this.changed("percent");
        this.emit("percent-changed", this.#percent);
    }

    connect(
        event = "percent-changed",
        callback: (_: typeof this, ...args: any) => void,
    ) {
        return super.connect(event, callback);
    }
}

export default new BrightnessService;

