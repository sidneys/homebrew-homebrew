cask 'flutter-dev' do
  version '1.21.0-1.0.pre'
  sha256 'fc9592842d859d1a6619d5302c97eb56bf587f7bcb984283289954933ae3d23d'

  url "https://storage.googleapis.com/flutter_infra/releases/dev/macos/flutter_macos_#{version}-dev.zip"
  name 'flutter'
  homepage 'https://flutter.dev'

  conflicts_with cask:    [
                            'flutter',
                            'flutter-beta'
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
