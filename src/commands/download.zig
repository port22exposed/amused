const std = @import("std");

const commands = @import("../commands.zig");

const Command = commands.Command;

pub fn execute (args: []const []const u8) !void {
    std.debug.print("Executing download with args: {any}\n", .{args});
}

pub const download = Command {
    .name = "download",
    .description = "Downloads a playlist",
    .execute = &execute
};