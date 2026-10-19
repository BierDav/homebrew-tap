cask "typewright@beta" do
  version "0.1.0-alpha.4"
  sha256 "36c4006f4be9415a2c7eda93a2bf748701aaec30ab040521688cf52d038c39a5"

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
