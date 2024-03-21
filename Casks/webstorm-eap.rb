cask "webstorm-eap" do
  arch arm: "-aarch64"

  version "2024.1,241.14494.109"
  sha256 arm:   "dcf4403b004af10cf3f30dea11ba4bdad8bfc456192fbeb0a5e3ede38bfd51d9",
         intel: "19872163b90a2fc6addbbdc5baf1e57f33c253b64c3490e6ce64122624970be4"

  url "https://download.jetbrains.com/webstorm/WebStorm-#{version.after_comma}#{arch}.dmg"
  name "WebStorm EAP"
  desc "JavaScript IDE"
  homepage "https://www.jetbrains.com/webstorm/eap/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=WS&latest=true&type=eap"
    strategy :json do |json|
      json["WS"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "WebStorm #{version.before_comma} EAP.app"
  binary "#{appdir}/WebStorm #{version.before_comma} EAP.app/Contents/MacOS/webstorm"

  zap trash: [
               "~/Library/Application Support/WebStorm#{version.major_minor}",
               "~/Library/Caches/WebStorm#{version.major_minor}",
               "~/Library/Logs/WebStorm#{version.major_minor}",
               "~/Library/Preferences/com.jetbrains.WebStorm-EAP.plist",
               "~/Library/Preferences/jetbrains.webstorm.*.plist",
               "~/Library/Preferences/WebStorm#{version.major_minor}",
               "~/Library/Saved Application State/com.jetbrains.WebStorm-EAP.savedState",
             ]
end
