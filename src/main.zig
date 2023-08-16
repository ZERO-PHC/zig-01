const std = @import("std");

fn nextLine(reader: anytype, buffer: []u8) !?[]const u8 {
    var line = (try reader.readUntilDelimiterOrEof(
        buffer,
        '\n',
    )) orelse return null;
    // trim annoying windows-only carriage return character
    if (@import("builtin").os.tag == .windows) {
        return std.mem.trimRight(u8, line, "\r");
    } else {
        return line;
    }
}

fn askUser(buffer: []u8) !?[]const u8 {
    const stdout = std.io.getStdOut();
    const stdin = std.io.getStdIn();
    try stdout.writeAll(
        \\ Enter your name:
    );

    const input = (try nextLine(stdin.reader(), buffer)).?;
    return input;
}

pub fn main() !void {
    const target = "wai";
    _ = target;

    const stdout = std.io.getStdOut();

    var buffer: [100]u8 = undefined;
    const userInput = askUser(&buffer) catch |err| {
        std.debug.print("Error: {}\n", .{err});
        return;
    };

    if (userInput) |value| {
        try stdout.writer().print(
            "Your name is: \"{s}\"\n",
            .{value},
        );
    }
}
