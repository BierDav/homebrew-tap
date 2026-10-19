# homebrew-tap

Personal [Homebrew](https://brew.sh) tap for BierDav's apps.

```sh
brew tap bierdav/tap
```

## Typewright

```sh
brew install --cask bierdav/tap/typewright        # stable
brew install --cask bierdav/tap/typewright@beta   # newest build of any channel
```

## parallels-install

```sh
brew install --cask bierdav/tap/parallels-install
```

Unattended nightly auto-updater for Parallels Desktop via a Telegram channel.
The release assets live in the private [`BierDav/parallels-install`](https://github.com/BierDav/parallels-install)
repository, so the cask downloads them through the GitHub API with credentials —
either an existing `gh auth login` / macOS keychain login, or

```sh
export HOMEBREW_GITHUB_API_TOKEN=<token with read access to BierDav/parallels-install>
```
