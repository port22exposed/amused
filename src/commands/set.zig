const std = @import("std");

const commands = @import("../commands.zig");

const Command = commands.Command;

pub fn execute (args: []const []const u8) !void {
    std.debug.print("Executing set with args: {any}\n", .{args});
}

pub const set = Command {
    .name = "set",
    .description = "Modifies a global setting",
    .execute = &execute
};