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

fn askUser() !void {
    const stdout = std.io.getStdOut();
    const stdin = std.io.getStdIn();
    try stdout.writeAll(
        \\ Enter your name:
    );

    var buffer: [100]u8 = undefined;
    const input = (try nextLine(stdin.reader(), &buffer)).?;
    var isZero = std.mem.eql(u8, input, "zero");
    if (isZero) {
        try stdout.writer().print(
            "Your name is: \"{s}\"\n",
            .{input},
        );
    } else {
        try stdout.writer().print("You arent zero your name is: {s}\n", .{input});
    }
}

test "read until next line" {
    const target = 9;
    _ = target;

    //TODO: return here the input value
    try askUser();
}
