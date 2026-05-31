# Peeper Language Support

Zed language support for the current Peeper language revision.

This extension currently provides:

- Tree-sitter based parsing
- syntax highlighting
- bracket matching
- indentation rules
- `.peep` file recognition
- LSP wiring (`peeper lsp`)

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
