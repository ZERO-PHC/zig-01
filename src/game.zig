const std = @import("std");

fn ask_user() !i64 {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    // defines the buffer into which the user input is read
    var buf: [10]u8 = undefined;

    try stdout.print("Guess a number", .{});

    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        return std.fmt.parseInt(i64, user_input, 10);
    } else {
        return error.invalidParam;
    }
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.os.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });

    const value = prng.random().intRangeAtMost(i64, 1, 100);
    while (true) {
        const guess = try ask_user();
        if (guess == value) {
            break;
        }

        const message =
            if (guess < value)
            "Too low"
        else
            "Too high";

        try stdout.print("Too {s}\n", .{message});
    }

    try stdout.print("That's right! \n", .{});
}
