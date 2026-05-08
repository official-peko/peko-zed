use zed_extension_api::{self as zed, LanguageServerId, Result};

struct PekoExtension {
    cached_binary_path: Option<String>,
}

impl zed::Extension for PekoExtension {
    fn new() -> Self {
        Self {
            cached_binary_path: None,
        }
    }

    fn language_server_command(
        &mut self,
        _language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let binary_path = self.language_server_binary(worktree)?;

        Ok(zed::Command {
            command: binary_path,
            args: vec![],
            env: worktree.shell_env(),
        })
    }
}

impl PekoExtension {
    fn language_server_binary(&mut self, worktree: &zed::Worktree) -> Result<String> {
        // Return cached path if we already found/downloaded it this session.
        if let Some(path) = &self.cached_binary_path {
            if std::fs::metadata(path).is_ok() {
                return Ok(path.clone());
            }
        }

        // Option A — check if it's already on PATH (good for dev / power users).
        if let Some(path) = worktree.which("peko_lsp") {
            self.cached_binary_path = Some(path.clone());
            return Ok(path);
        }

        // Option B — download from GitHub Releases for the current platform.
        let release = zed::latest_github_release(
            "official-peko/pekols",
            zed::GithubReleaseOptions {
                require_assets: true,
                pre_release: false,
            },
        )?;

        // Determine the correct asset name for the current platform
        let (os, arch) = zed::current_platform();
        let (asset_name, file_type, binary_name) = match (os, arch) {
            (zed::Os::Mac, zed::Architecture::Aarch64) => (
                "peko-ls-aarch64-apple-darwin.tar.gz",
                zed::DownloadedFileType::GzipTar,
                "peko_lsp",
            ),
            (zed::Os::Mac, zed::Architecture::X8664) => (
                "peko-ls-x86_64-apple-darwin.tar.gz",
                zed::DownloadedFileType::GzipTar,
                "peko_lsp",
            ),
            (zed::Os::Linux, zed::Architecture::X8664) => (
                "peko-ls-x86_64-unknown-linux-gnu.tar.gz",
                zed::DownloadedFileType::GzipTar,
                "peko_lsp",
            ),
            (zed::Os::Linux, zed::Architecture::Aarch64) => (
                "peko-ls-aarch64-unknown-linux-gnu.tar.gz",
                zed::DownloadedFileType::GzipTar,
                "peko_lsp",
            ),
            (zed::Os::Windows, zed::Architecture::X8664) => (
                "peko-ls-x86_64-pc-windows-msvc.zip",
                zed::DownloadedFileType::Zip,
                "peko_lsp.exe",
            ),
            (os, arch) => return Err(format!("unsupported platform: {os:?} {arch:?}")),
        };

        // Find the matching asset in the release
        let asset = release
            .assets
            .iter()
            .find(|a| a.name == asset_name)
            .ok_or_else(|| format!("no asset found for platform: {asset_name}"))?;

        // download_file extracts archives into the directory you provide.
        // binary_path points at the executable inside that directory.
        let download_dir = format!("peko-ls/{}", release.version);
        let binary_path = format!("{}/{}", download_dir, binary_name);

        // Only download if we don't already have this version
        if std::fs::metadata(&binary_path).is_err() {
            zed::download_file(
                &asset.download_url,
                &download_dir, // ← extract into the versioned directory
                file_type,
            )
            .map_err(|e| format!("failed to download pekoscript-lsp: {e}"))?;

            zed::make_file_executable(&binary_path)?;
        }

        self.cached_binary_path = Some(binary_path.clone());
        Ok(binary_path)
    }
}

zed::register_extension!(PekoExtension);
