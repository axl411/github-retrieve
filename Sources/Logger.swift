import Darwin.C.stdio

struct Logger {
    @MainActor func logStdout(_ message: String) {
        fputs(message + "\n", stdout)
    }

    @MainActor func logStderr(_ message: String) {
        fputs(message + "\n", stderr)
    }
}
