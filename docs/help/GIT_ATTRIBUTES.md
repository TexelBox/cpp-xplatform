- Every repository should have a `.gitattributes` file in the project root directory.
- This file is used for specifying attributes to pattern-matched paths. These attributes affect certain git operations (e.g. check-out and check-in).
- Notably, it is useful for overriding the `core.autocrlf` setting in a developer's `.gitconfig` (usually the global config). This ensures that for text files, line-endings in the repository are normalized (to '\LF' - with some overrides for specific file types).

**NOTE: regardless, it is usually recommended to have `core.autocrlf` setting as `true` on Windows and `input` on Linux/macOS.**
