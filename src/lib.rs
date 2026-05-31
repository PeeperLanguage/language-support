use zed_extension_api::{self as zed, settings::LspSettings, LanguageServerId, Result};

struct PeeperBinary {
    path: String,
    args: Option<Vec<String>>,
}

struct PeeperExtension;

impl PeeperExtension {
    const LANGUAGE_SERVER_ID: &'static str = "peeper";

    fn language_server_binary(
        &self,
        _language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<PeeperBinary> {
        let binary_settings = LspSettings::for_worktree(Self::LANGUAGE_SERVER_ID, worktree)
            .ok()
            .and_then(|settings| settings.binary);
        let binary_args = binary_settings
            .as_ref()
            .and_then(|settings| settings.arguments.clone());

        if let Some(path) = binary_settings
            .as_ref()
            .and_then(|settings| settings.path.as_ref())
            .filter(|path| !path.trim().is_empty())
            .cloned()
        {
            return Ok(PeeperBinary {
                path,
                args: binary_args,
            });
        }

        if let Some(path) = worktree.which("peeper") {
            return Ok(PeeperBinary {
                path,
                args: binary_args,
            });
        }

        Err("The Peeper language server binary (peeper) is not available in your environment (PATH). Configure `lsp.peeper.binary.path` or install `peeper`.".to_string())
    }
}

impl zed::Extension for PeeperExtension {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let binary = self.language_server_binary(language_server_id, worktree)?;

        Ok(zed::Command {
            command: binary.path,
            args: binary.args.unwrap_or_else(|| vec!["lsp".to_string()]),
            env: worktree.shell_env(),
        })
    }

    fn language_server_initialization_options(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<Option<zed::serde_json::Value>> {
        let settings =
            LspSettings::for_worktree(language_server_id.as_ref(), worktree).unwrap_or_default();
        Ok(settings.initialization_options)
    }

    fn language_server_workspace_configuration(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<Option<zed::serde_json::Value>> {
        let settings =
            LspSettings::for_worktree(language_server_id.as_ref(), worktree).unwrap_or_default();
        Ok(settings.settings)
    }
}

zed::register_extension!(PeeperExtension);
