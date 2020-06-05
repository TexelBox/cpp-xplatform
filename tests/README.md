THIS DIRECTORY IS FOR ANY EXTERNAL TEST CODE.
- NOTE: subdirectory format should be similar to that in src/.

---

- NOTE: some useful compile-definitions / macros that can be used in all these files are...
    - `PATH_TO_ASSETS_DIRECTORY` (absolute path string to the assets/ directory that should be used as a prefix to all paths of specific assets to read/write/etc. This practice is to ensure that assets can be referenced regardless of the CWD when running the executable.)
    - `PATH_TO_BUILD_SYSTEM_DIRECTORY` (absolute path string to the directory containing the respective build-system files (e.g. .vcxproj, Makefile, etc.).)
    - `PATH_TO_PROJECT_ROOT_DIRECTORY` (absolute path string (self-explanatory - i.e. the directory the entire project gets cloned into).)
