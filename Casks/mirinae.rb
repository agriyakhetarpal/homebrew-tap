# Installs the prebuilt release. The binary is ad hoc signed, not notarised, so macOS asks
# for confirmation on first launch unless the user installs with --no-quarantine.
cask "mirinae" do
  version "0.1.1"
  sha256 "4c76ed1b7f8c472a675b9bba5f9cbbc3ed625a59048253d7ac0e7c4fdc7543e7"

  url "https://github.com/agriyakhetarpal/mirinae/releases/download/v#{version}/Mirinae-#{version}.zip"
  name "Mirinae"
  desc "Galaxy Buds controls, diagnostics, and a menu bar panel"
  homepage "https://github.com/agriyakhetarpal/mirinae"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Mirinae.app"

  uninstall launchctl: "al.agriyakhetarp.mirinae.watcher",
            quit:      "al.agriyakhetarp.mirinae"

  zap trash: [
    "~/Library/LaunchAgents/al.agriyakhetarp.mirinae.watcher.plist",
    "~/Library/Preferences/al.agriyakhetarp.mirinae.plist",
    "~/Library/Saved Application State/al.agriyakhetarp.mirinae.savedState",
  ]

  caveats do
    <<~EOS
      Mirinae is not notarised. On first launch macOS will say it could not verify the app.
      Open System Settings > Privacy & Security, scroll down, and click "Open Anyway".
      To skip that step, install with: brew install --cask --no-quarantine agriyakhetarpal/tap/mirinae
    EOS
  end
end
