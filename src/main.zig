const std = @import("std");

const commands = @import("commands.zig").list;

fn printHelp() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Usage: amused <subcommand> [args...]\n\n", .{});
    try stdout.print("Available subcommands:\n", .{});
    for (commands) |cmd| {
        try stdout.print("  {s:<15} {s}\n", .{ cmd.name, cmd.description });
    }
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    var argList = std.ArrayList([]const u8).init(allocator);
    defer argList.deinit();

    while (args.next()) |arg| {
        try argList.append(arg);
    }

    const argc = argList.items.len;

    if (argc < 2) {
        try printHelp();
        return;
    }

    const subcommand = argList.items[1];
    for (commands) |cmd| {
        if (std.mem.eql(u8, subcommand, cmd.name)) {
            try cmd.execute(argList.items[2..]);
            return;
        }
    }

    try printHelp();
}
