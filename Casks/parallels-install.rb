# Fetches a release asset from a private GitHub repository. The cask keeps a
# normal `releases/download` URL and the token is attached only at download
# time, so loading (or `brew update`-ing) the tap makes no GitHub API calls.
#
# Credentials come from `HOMEBREW_GITHUB_API_TOKEN`, or — when that is unset —
# from whatever `GitHub::API` finds (`gh auth login`, keychain, …). Set the env
# var on machines without an authenticated `gh`.
class GitHubPrivateReleaseDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    match = url.match %r{^https://github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/([^/]+)$}
    raise CurlDownloadStrategyError.new(url, "Not a GitHub release asset URL.") unless match

    @owner, @repo, @tag, @filename = match.captures
  end

  private

  def asset
    @asset ||= begin
      require "utils/github"
      release = GitHub::API.open_rest(
        GitHub.url_to("repos", @owner, @repo, "releases", "tags", @tag),
        scopes: ["repo"],
      )
      found = release.fetch("assets").find { |a| a.fetch("name") == @filename }
      raise CurlDownloadStrategyError.new(url, "No release asset named #{@filename}.") unless found

      found
    end
  end

  def resolve_url_basename_time_file_size(_url, timeout: nil)
    [
      asset.fetch("url"),
      @filename,
      Time.parse(asset.fetch("updated_at")),
      asset.fetch("size"),
      asset.fetch("content_type"),
      false,
    ]
  end

  def _fetch(url:, resolved_url:, timeout:)
    require "utils/github"
    token = ENV["HOMEBREW_GITHUB_API_TOKEN"]
    token = GitHub::API.credentials if token.nil? || token.empty?
    header = ["Accept: application/octet-stream"]
    header << "Authorization: Bearer #{token}" unless token.to_s.empty?
    curl_download(resolved_url, to: temporary_path, try_partial: @try_partial, timeout: timeout, header: header)
  end
end

cask "parallels-install" do
  version "0.5.2"
  sha256 "b275756ef46b2c6fbca9b4491458556f7fe8c58f56a355a82f9797496f47ed70"

  url "https://github.com/BierDav/parallels-install/releases/download/v#{version}/parallels-install-macos-arm64.tar.gz",
      using: GitHubPrivateReleaseDownloadStrategy
  name "parallels-install"
  desc "Unattended nightly auto-updater for Parallels Desktop via a Telegram channel"
  homepage "https://github.com/BierDav/parallels-install"

  depends_on arch: :arm64
  depends_on macos: :ventura

  binary "parallels-install"

  # libtdjson.dylib is bundled alongside the binary (see scripts/release.sh) and
  # loaded via @executable_path, so no Homebrew `tdlib` dependency is needed —
  # that used to pull in whatever stale bottle brew had, which Telegram's
  # servers silently reject logins from.

  # Ad-hoc-signed CLI + bundled ad-hoc-signed libtdjson.dylib: strip the download
  # quarantine from the whole staged directory, not just the binary — an
  # untouched quarantine flag on the dylib makes dyld's Gatekeeper check hang
  # forever on first launch in a headless session (no GUI to show the prompt).
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{staged_path}}"]
  end

  caveats <<~EOS
    The release lives in a private GitHub repository. If downloads fail, make
    sure a GitHub token with repo access is available — either log in with
    `gh auth login` or export HOMEBREW_GITHUB_API_TOKEN.

    Get started with one command:
      parallels-install init

    It walks you through everything: config, Telegram login, admin password,
    a first update, and the nightly agent. Run "parallels-install status" any time.

    Note: the DMGs are third-party patched builds from @qiuchenlymac.
  EOS
end
