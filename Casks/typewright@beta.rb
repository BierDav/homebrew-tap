cask "typewright@beta" do
  version "0.1.0-rc.4"
  sha256 "8048335b3156fdd613bf93e0386cbea512cfaa972f62f5427f0955eb737f0008"

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
