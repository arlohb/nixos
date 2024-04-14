declare global {
    interface String {
        clip(len: number): string;
    }
}

String.prototype.clip = function (len: number): string {
    if (this.length > len) {
        const trimmed = this.substring(0, len - 2);
        return `${trimmed}...`;
    } else {
        return this.toString();
    }
};

export {}

