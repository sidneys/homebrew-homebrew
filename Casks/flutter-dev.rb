cask "flutter-dev" do
  version "1.26.0-17.2.pre"
  sha256 "56b8fcaf888efb162ff3e7083fd3d01f13369bf9be326f67c5e17e1e1b84b7a6"

  url "https://storage.googleapis.com/flutter_infra/releases/dev/macos/flutter_macos_#{version}-dev.zip"
  name "Flutter SDK"
  desc "UI toolkit for building applications for mobile, web and desktop"
  homepage "https://flutter.dev/"

  conflicts_with cask:    [
                            'flutter',
                            'flutter-beta'
                          ]

  auto_updates true
  depends_on macos: ">= :catalina"

  binary "flutter/bin/dart"
  binary "flutter/bin/flutter"
end
