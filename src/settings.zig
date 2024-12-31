const std = @import("std");
const builtin = @import("builtin");

const fs = std.fs;

fn file_exists(path: []const u8) bool {
    const file = fs.openFileAbsolute(path, .{ .mode = .read_only }) catch return false;
    defer file.close();

    const stat = file.stat() catch return false;
    return stat.kind == .file;
}

pub fn ensure_directory_exists(path: []const u8) void {
    fs.makeDirAbsolute(path) catch {};
}

fn get_setting_absolute_path(allocator: std.mem.Allocator, name: []const u8) ![]u8 {
    const appData = fs.getAppDataDir(allocator, "amusing") catch |err| switch (err) {
        error.OutOfMemory => {
            std.log.err("Application could not store the AppData directory path into memory!", .{});
            std.process.exit(1);
        },
        error.AppDataDirUnavailable => {
            std.log.err("AppData directory unavailable!", .{});
            std.process.exit(1);
        },
    };
    defer allocator.free(appData);

    ensure_directory_exists(appData);

    const settings = try fs.path.join(allocator, &[_][]const u8{ appData, "settings" });
    defer allocator.free(settings);

    ensure_directory_exists(settings);

    const path = try fs.path.join(allocator, &[_][]const u8{ appData, "settings", name });

    return path;
}

pub fn is_set(allocator: std.mem.Allocator, name: []const u8) !bool {
    const path = try get_setting_absolute_path(allocator, name);
    defer allocator.free(path);

    return file_exists(path);
}

test "is_set" {
    const allocator = std.testing.allocator;

    _ = try is_set(allocator, "GENIUS_ACCESS_TOKEN");
}

pub fn read_setting(allocator: std.mem.Allocator, name: []const u8) ![]u8 {
    const path = try get_setting_absolute_path(allocator, name);
    defer allocator.free(path);

    const file = try fs.openFileAbsolute(path, .{ .mode = .read_only });
    defer file.close();

    const endPos = try file.getEndPos();

    const content = try file.readToEndAlloc(allocator, endPos);

    return content;
}

test "read_setting" {
    const allocator = std.testing.allocator;

    if (try is_set(allocator, "GENIUS_ACCESS_TOKEN")) {
        const contents = try read_setting(allocator, "GENIUS_ACCESS_TOKEN");
        defer allocator.free(contents);
    }
}

pub fn write_setting(allocator: std.mem.Allocator, name: []const u8, value: []const u8) !void {
    const path = try get_setting_absolute_path(allocator, name);
    defer allocator.free(path);

    const file = try fs.createFileAbsolute(path, .{});
    defer file.close();

    _ = try file.write(value);
}

test "write_setting" {
    const allocator = std.testing.allocator;

    try write_setting(allocator, "GENIUS_ACCESS_TOKEN", "completely valid genius.com access token");
}
