cask "telegram-beta" do
  version :latest
  sha256 :no_check

  url do
    require "open-uri"
    require "nokogiri"

    builds_url = "https://api.appcenter.ms/v0.1/public/sparkle/apps/6ed2ac30-49e1-4073-87c2-f1ffcb74e81f"
    doc = Nokogiri.XML(URI(builds_url).open) { |config| config.recover.noent }
    latest_build_url = doc.xpath("/rss/channel/item[1]/enclosure/@url").text.to_s

    latest_build_url
  end

  name "Telegram for macOS"
  desc "Messaging app with a focus on speed and security"
  homepage "https://macos.telegram.org/"

  conflicts_with cask: "telegram"
  depends_on macos: ">= :el_capitan"

  app "Telegram.app"

  zap trash: [
    "~/Library/Application Scripts/ru.keepcoder.Telegram",
    "~/Library/Application Scripts/ru.keepcoder.Telegram.TelegramShare",
    "~/Library/Caches/ru.keepcoder.Telegram",
    "~/Library/Containers/ru.keepcoder.Telegram",
    "~/Library/Containers/ru.keepcoder.Telegram.TelegramShare",
    "~/Library/Cookies/ru.keepcoder.Telegram.binarycookies",
    "~/Library/Group Containers/*.ru.keepcoder.Telegram",
    "~/Library/Preferences/ru.keepcoder.Telegram.plist",
    "~/Library/Saved Application State/ru.keepcoder.Telegram.savedState",
  ]
end
