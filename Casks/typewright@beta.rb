cask "typewright@beta" do
  version "0.1.0-alpha.5"
  sha256 "1d09e621bfe6365cb9c01d67c4b8383bb2c3f9674363015d0a9836bc3d54c4d7"

  url "https://github.com/BierDav/typewright/releases/download/v#{version}/Typewright-#{version}.zip"
  name "Typewright"
  desc "Native Typst editor with live preview"
  homepage "https://github.com/BierDav/typewright"

  depends_on macos: :tahoe
  conflicts_with cask: "typewright"

  app "Typewright.app"

  # Ad-hoc signed; clear quarantine so Gatekeeper lets it launch.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Typewright.app"]
  end

  zap trash: [
    "~/Library/Application Support/Typewright",
    "~/Library/Preferences/dev.bierdav.Typewright.plist",
  ]
end
