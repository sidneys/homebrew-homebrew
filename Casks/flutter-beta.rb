cask 'flutter-beta' do
  version '1.20.0-7.2.pre'
  sha256 'ead0524aa5262f872e369448f6ee1eccdfb0636704c8d4208a4ab2ec6da87a15'

  url "https://storage.googleapis.com/flutter_infra/releases/beta/macos/flutter_macos_#{version}-beta.zip"
  name 'flutter'
  homepage 'https://flutter.dev'

  conflicts_with cask:    [
                            'flutter-beta',
                            'flutter-dev'
                          ]

  binary 'flutter/bin/flutter', target: 'flutter'

  postflight do
    # Upgrade channel to the latest version
    system_command '/usr/local/bin/flutter',
                   args: [
                       'upgrade',
                       '--force'
                     ],
                   sudo: false
  end
end
