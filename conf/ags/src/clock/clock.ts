export const getTime = () => Variable({ hours: 0, mins: 0 }, {
    poll: [1000, () => {
        const date = new Date();
        return {
            hours: date.getHours(),
            mins: date.getMinutes(),
        };
    }],
});


