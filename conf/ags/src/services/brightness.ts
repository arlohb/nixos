import { cmdExists } from "@utils";

const clamp = (value: number, min: number, max: number): number => {
    const a = Math.max(value, min);
    return Math.min(a, max);
}

class BrightnessDDCService extends Service {
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

    #interface: string;
    #brightnessId: string;

    /** The brightness percent from 0 to 1 */
    #percent: number = 0;
    #max: number;

    get percent() {
        return this.#percent;
    }

    set percent(percent: number) {
        this.#percent = clamp(percent, 0, 1);

        Utils.execAsync(`ddccontrol dev:${this.#interface} -r ${this.#brightnessId} -w ${this.#percent * this.#max}`);
    }

    constructor() {
        super();

        const lines =  Utils.exec("ddccontrol -p").split("\n");

        const deviceLine = lines.find(line => line.startsWith(" - Device: "))!;
        this.#interface = deviceLine.split("dev:")[1];

        const brightnessLineIndex = lines.findIndex(line => line.startsWith("\t\t> id=brightness"));
        this.#brightnessId = lines[brightnessLineIndex].split("address=")[1].split(",")[0];
        this.#max = Number(lines[brightnessLineIndex + 1].split("maximum=")[1]);

        const _this = this;
        setInterval(function () { _this.#onChange(); }, 2 * 1000);
    }

    #onChange() {
        const lines = Utils.exec(`ddccontrol dev:${this.#interface} -r ${this.#brightnessId}`).split("\n");
        const brightness = Number(lines[lines.length - 1].split("/")[1]);
        const percent = brightness / this.#max;

        if (percent !== this.#percent) {
            this.#percent = percent;

            this.changed("percent");
            this.emit("percent-changed", this.#percent);
        }
    }

    connect(
        event = "percent-changed",
        callback: (_: typeof this, ...args: any) => void,
    ) {
        return super.connect(event, callback);
    }
}

class BrightnessctlService extends Service {
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

const service = cmdExists("brightnessctl")
    ? new BrightnessctlService
    : cmdExists("ddccontrol")
        ? new BrightnessDDCService
        : null;

export default service;

