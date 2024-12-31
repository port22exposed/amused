const std = @import("std");

pub const Command = struct {
    name: []const u8,
    description: []const u8,
    execute: *const fn ([]const []const u8) anyerror!void,
};

const download = @import("./commands/download.zig").download;
const set = @import("./commands/set.zig").set;

pub const list = [_]Command{ download, set };
