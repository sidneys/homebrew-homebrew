cask "teamspeak-client-prerelease" do
  version "5.0.0-beta67"
  sha256 "090b778fa2d28aa9b319d6a1c231ee64ff6be5c7afc9162d4f2a086aec6fb06f"

  url "https://files.teamspeak-services.com/pre_releases/client/#{version}/teamspeak-client.dmg",
      verified: "files.teamspeak-services.com/"

  livecheck do
    skip "No version information available"
  end

  name "TeamSpeak Prerelease"
  desc "Voice communication client"
  homepage "https://www.teamspeak.com/"

  depends_on macos: ">= :sierra"

  app "TeamSpeak.app"

  zap trash: [
    "~/Library/Caches/TeamSpeak",
    "~/Library/Logs/TeamSpeak",
    "~/Library/Preferences/TeamSpeak",
    "~/Library/Saved Application State/com.teamspeak.#{version.major}.client.savedState",
  ]
end
