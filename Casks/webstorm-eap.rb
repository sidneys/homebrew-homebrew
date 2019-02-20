cask 'webstorm-eap' do
  version '2019.1,191.5532.37'
  sha256 '154fec30cfb3bbbdf8110293e8e4b369ebf39c828896c073f02a85ea6a88a2b3'

  url "https://download.jetbrains.com/webstorm/WebStorm-#{version.after_comma}.dmg"
  appcast 'https://data.services.jetbrains.com/products/releases?code=WS&latest=true&type=eap'
  name 'WebStorm EAP'
  homepage 'https://www.jetbrains.com/webstorm/eap/'

  auto_updates true

  app "WebStorm #{version.before_comma} EAP.app"

  uninstall_postflight do
    ENV['PATH'].split(File::PATH_SEPARATOR).map { |path| File.join(path, 'wstorm') }.each { |path| File.delete(path) if File.exist?(path) && File.readlines(path).grep(%r{# see com.intellij.idea.SocketLock for the server side of this interface}).any? }
  end

  zap trash: [
               "~/Library/Application Support/WebStorm#{version.major_minor}",
               "~/Library/Caches/WebStorm#{version.major_minor}",
               "~/Library/Logs/WebStorm#{version.major_minor}",
               "~/Library/Preferences/WebStorm#{version.major_minor}",
               '~/Library/Preferences/com.jetbrains.WebStorm-EAP.plist',
               '~/Library/Saved Application State/com.jetbrains.WebStorm-EAP.savedState',
             ]
end
