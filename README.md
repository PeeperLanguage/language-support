# Peeper Language Support

Zed language support for the current Peeper language revision.

This extension currently provides:

- Tree-sitter based parsing
- syntax highlighting
- bracket matching
- indentation rules
- `.peep` file recognition
- LSP wiring (`peeper lsp`)
- `with` enum payload construction and match-pattern highlighting

## Struct literals and grammar integration

Named struct literals use `Point.{ x = 1, y = 2 }`. Generic and qualified forms include `Box<i32>.{ value = 1 }` and `geometry::Point.{ x = 1 }`. Inferred literals use `.{ ... }`, fields use `field = value`, and enum payloads use `Result<Point>::Ok with Point.{ x = 1 }` or `with .{ x = 1 }`. See `main.peep` for parsing/highlighting examples, including control headers.

`extension.toml` loads the published `tree-sitter-peeper` grammar from remote `master`. Local parser/query tests use the sibling grammar checkout; Zed fetches the revision configured in `extension.toml`.

To validate these queries and examples against the sibling grammar without changing the remote revision, run from `../tree-sitter-peeper`:

```sh
npm run generate
npm test
node_modules/.bin/tree-sitter parse ../language-support/main.peep
node_modules/.bin/tree-sitter query ../language-support/languages/peeper/highlights.scm ../language-support/main.peep
node_modules/.bin/tree-sitter query ../language-support/languages/peeper/brackets.scm ../language-support/main.peep
node_modules/.bin/tree-sitter query ../language-support/languages/peeper/indents.scm ../language-support/main.peep
```

For repeatable integration assertions, run from this repository after generating the sibling grammar:

```sh
python3 -B -m unittest discover -s test -v
cargo test --offline
cargo build --offline --target wasm32-wasip2
```

The Python tests require the sibling checkout and its `npm`-installed Tree-sitter CLI. They parse `main.peep`, compile all Peeper queries, and check type/property/dot/enum captures, including that qualified struct type names are not captured as enum constructors. Cargo builds require cached dependencies for `--offline` and the installed `wasm32-wasip2` target.

These checks cover local parser/query compatibility and the Rust extension. Editor-session behavior requires Zed validation. Completion behavior is supplied by the compiler LSP.

## LSP command resolution

The extension resolves the language server command in this order:

1. `lsp.peeperls.binary.path` (if configured)
2. `peeper` from your PATH (`worktree.which("peeper")`)

The extension passes `lsp` as default args. You can override args with `lsp.peeperls.binary.arguments`.

Example Zed settings:

```json
{
	"lsp": {
		"peeperls": {
			"binary": {
				"path": "/home/fuad/Dev/PeeperLang/Peeper/bin/peeper",
				"arguments": ["lsp"]
			}
		}
	}
}
```

## LSP settings key

Zed LSP settings are read from `peeperls` via:

- `initialization_options`
- `settings`

Command launch configuration is read separately from `lsp.peeperls.binary`.Peeper

## Steps to Update an Extension Submodule

### 1. Check Current Status
```bash
git submodule status
```
This shows which submodules have updates available.

### 2. Update the Submodule
```bash
git submodule update --remote extensions/peeper
```
This pulls the latest changes from the submodule's remote repository.

### 3. Update Version in extensions.toml
If the extension version changed, update the version number in `extensions.toml`:

```toml
[extension-name]
submodule = "extensions/extension-name"
version = "x.x.x"  # Update this
```

### 4. Stage and Commit Changes
```bash
git add extensions.toml extensions/[extension-name]
git commit -m "Update [extension-name] extension to version x.x.x"
```

### 5. Push Changes
```bash
git push
```

## Example: Updating Peeper Extension

```bash
# Check status
git submodule status

# Update submodule
git submodule update --remote extensions/peeper

# Update version in extensions.toml (if needed)
# Edit extensions.toml to bump version

# Stage and commit
git add extensions.toml extensions/peeper
git commit -m "Update peeper to vX.X.X"

# Push
git push
```

## Notes
- Always check `git submodule status` first to see what needs updating
- The submodule path is `extensions/[extension-name]`
- Version numbers should match what's in the extension's own repository
- Test locally before pushing if possible
