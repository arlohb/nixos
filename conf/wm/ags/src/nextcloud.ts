const time = Variable(0, {
    poll: [1000, () => {
        const dateStr = Utils.exec(`fish -c " \
            systemctl show --user nextcloud-sync.service --property=ExecMainExitTimestamp \
            | awk -F= '{print \\$2}' \
        "`)

        const timeStr = dateStr.split(" ")[2];

        if (timeStr === undefined) {
            return 0;
        }

        const [h, m, s] = timeStr.split(":").map(str => Number.parseInt(str));

        const lastRan = new Date();
        lastRan.setHours(h);
        lastRan.setMinutes(m);
        lastRan.setSeconds(s);
        lastRan.setMilliseconds(0);

        const now = new Date();

        const secs = Math.round((now.getTime() - lastRan.getTime()) / 1000);

        return secs;
    }],
});

export default () => Widget.Box({
    vertical: true,
    spacing: 8,
    className: "widget nextcloud",
    children: [
        Widget.Label("󰅟"),
        Widget.Label({
            label: time.bind().as(time => `${time}s`),
        }),
    ],
});

