**https://editorconfig.org/**
- EditorConfig is an attempt at a standardized format for coding style.
- EditorConfig support/extensions in your IDE (Visual Studio 2017/2019 have it by default) or text editor are required if you (and especially your team) want to take advantage of consistent coding standards (e.g. line-endings, indentation (spaces vs. tabs, size), whitespace trimming, etc.).
- The `.editorconfig` file is placed in the project root directory. When you open a file in the same directory or any recursive child directories with your editor, it will recursively search up the directory chain finding all `.editorconfig` files until it finds one marked as `root = true` and stops. All found config files will affect your editor settings for the specific file you are editing, but we only have the one file for simplicity.
- If working in a team, it is important to know that different EditorConfig extensions may behave slightly differently and thus when someone else works on a file you committed (after being formatted by your version of EditorConfig), they might make slight formatting changes that can be annoying in commit diffs.

**NOTE: if you are working in VSCode, along with installing the EditorConfig extension, you may also have to `npm install -g editorconfig`**
