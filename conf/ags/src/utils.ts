import Gio from "types/@girs/gio-2.0/gio-2.0";
import Gdk from "gi://Gdk";

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

/** Get a list of the FileInfo for each file or directory in a directory. */
export const readDirFileInfos = (path: string): Gio.FileInfo[] => {
    const files: Gio.FileInfo[] = [];

    // Open the directory
    var dir = Gio.File.new_for_path(path);

    // If this isn't a directory
    const dirType = dir.query_info("standard::type", Gio.FileQueryInfoFlags.NONE, null).get_file_type();
    if (dirType != Gio.FileType.DIRECTORY) {
        // Open the parent instead
        const parent = dir.get_parent();
        if (parent != null) {
            dir = parent;
        }
    }

    // For each child
    const children = dir.enumerate_children("standard::name,standard::type", Gio.FileQueryInfoFlags.NONE, null);
    let fileInfo;
    while (fileInfo = children.next_file(null)) {
        // Add to return
        files.push(fileInfo);
    }

    return files;
}

/** Get a list of all the file or directory names and types in a directory. */
export const listDir = (path: string): [string, Gio.FileType][] => {
    return readDirFileInfos(path)
        // Only keep the name and file type
        .map(fileInfo => [
            fileInfo.get_name(),
            fileInfo.get_file_type(),
        ]);
}

/** Get all the absolute paths of files in a directory recursively. */
export const listDirRecAbsolute = (path: string): string[] => {
    return listDir(path)
        .flatMap(([name, type]) =>
            // Read recursively if this is a directory
            type == Gio.FileType.DIRECTORY
                ? listDirRecAbsolute(`${path}/${name}`)
                : [ `${path}/${name}` ]
        )
}

/** Get all the relative paths of files in a directory recursively. */
export const listDirRecRelative = (path: string): string[] => {
    return listDirRecAbsolute(path)
        // Remove the original path to make relative
        .map(name => name.slice(path.length + 1));
}

/** Checks if a cmd exists using `which`. */
export const cmdExists = (cmd: string): boolean => {
    return "" !== Utils.exec(`bash -c "which ${cmd}"`);
};

/** Get the GDK ID of the screen with the biggest width. */
export const getMainMonitor = (): number => {
    const display = Gdk.Display.get_default()!;

    const count = display.get_n_monitors();
    const monitors: [number, Gdk.Monitor][] = [...Array(count).keys()]
        .map(n => [n, display.get_monitor(n)!]);

    const [maxMonitorId, _] = monitors.reduce(
        ([maxMonitorId, maxWidth], [monitorId, monitor]) => {
            const width = monitor?.geometry.width!;
            return width > maxWidth
                ? [monitorId, width]
                : [maxMonitorId, maxWidth];
        },
        [-1, -1],
    );

    return maxMonitorId;
};

