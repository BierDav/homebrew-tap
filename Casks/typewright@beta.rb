cask "typewright@beta" do
  version "0.1.0-alpha.8"
  sha256 "7894cbb98172b11fefe2f7d8a508d13f0dcd444fa55004e2f5d6f2e2fad525f6"

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
