const std = @import("std");

pub const Command = struct {
    name: []const u8,
    description: []const u8,
    execute: *const fn ([]const []const u8) anyerror!void,
};

pub fn setExecute (args: []const []const u8) !void {
    std.debug.print("Executing set with args: {any}\n", .{args});
}

pub const set = Command {
    .name = "set",
    .description = "Modifies a global setting",
    .execute = &setExecute
};


pub fn downloadExecute (args: []const []const u8) !void {
    std.debug.print("Executing download with args: {any}\n", .{args});
}

pub const download = Command {
    .name = "download",
    .description = "Downloads a playlist",
    .execute = &downloadExecute
};
