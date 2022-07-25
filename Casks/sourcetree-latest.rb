cask 'sourcetree-latest' do
  version :latest
  sha256 :no_check

  # bitbucket.org/atlassianlabs/sourcetree-betas was verified as official when first introduced to the cask
  url 'https://bitbucket.org/atlassianlabs/sourcetree-betas/downloads/OSX_Latest.zip'
  name 'Atlassian Sourcetree'
  homepage 'https://www.sourcetreeapp.com/'

  depends_on macos: '>= :mojave'

  app 'Sourcetree.app'
  binary "#{appdir}/Sourcetree.app/Contents/Resources/stree"

  uninstall launchctl: 'com.atlassian.SourceTreePrivilegedHelper2',
            quit:      'com.torusknot.SourceTreeNotMAS'

  zap trash: [
               '~/Library/Application Support/SourceTree',
               '~/Library/Caches/com.torusknot.SourceTreeNotMAS',
               '~/Library/Preferences/com.torusknot.SourceTreeNotMAS.plist',
               '~/Library/Preferences/com.torusknot.SourceTreeNotMAS.LSSharedFileList.plist',
               '~/Library/Saved Application State/com.torusknot.SourceTreeNotMAS.savedState',
             ]
end
