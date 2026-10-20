cask "typewright@beta" do
  version "0.1.0-rc.1"
  sha256 "1cd6b1b3db4313409fc250fc8a727940622ebfa15efa1ad617ae227a792e8065"

  url "https://github.com/BierDav/typewright/releases/download/v#{version}/Typewright-#{version}.zip"
  name "Typewright"
  desc "Native Typst editor with live preview"
  homepage "https://github.com/BierDav/typewright"

  depends_on macos: :tahoe
  conflicts_with cask: "typewright"

  app "Typewright.app"

  zap trash: [
    "~/Library/Application Support/Typewright",
    "~/Library/Preferences/dev.bierdav.Typewright.plist",
  ]
end
