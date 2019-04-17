cask 'ezcast' do
  version '2.8.0'
  sha256 'a6de63bbec9d8f8541f6f593f59909f31fa6a32627bb31dcf0370da748b05800'

  url "https://www.ezcast.com/upgrade/ezcast/EZCast-And-Driver-Installer-#{version}.pkg"
  appcast 'https://www.ezcast.com/upgrade/ezcast/maccast.xml'
  name 'EZCast'
  homepage 'https://www.ezcast.com/app/ezcast/macos'

  auto_updates true

  pkg "EZCast-And-Driver-Installer-#{version}.pkg"

  uninstall quit:    'com.ActionsMicro.EZCast',
            script:  {
                       executable: "#{appdir}/EZCast/Uninstall.command",
                       sudo:       false,
                     },
            pkgutil: [
                       'com.ActionsMicro.EZCast',
                       'com.Actions-Micro.drivers',
                     ],
            delete:  [
                       "#{appdir}/EZCast",
                       "#{appdir}/EZCast.app",
                     ]

  zap trash: [
               '~/Library/Caches/org.pqrs.PCKeyboardHack',
               '~/Library/Caches/org.pqrs.Seil',
               '~/Library/Preferences/org.pqrs.PCKeyboardHack.plist',
               '~/Library/Preferences/com.ActionsMicro.EZCast.plist',
             ]

  caveats do
    reboot
  end
end
