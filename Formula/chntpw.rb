class Chntpw < Formula
  desc "The Offline NT Password Editor"
  homepage "https://github.com/Tody-Guo/chntpw"
  url "https://github.com/sidneys/chntpw/archive/0.99.6.tar.gz"
  sha256 "e915f5addc2673317285c6f022c94da7fdee415d9800cd38540a13706706786b"
  head "https://github.com/sidneys/chntpw.git"

  depends_on "sidneys/homebrew/openssl@1.0"

  def install
    if Hardware::CPU.arm?
      # Homebrew on M1 appears to install here instead of /usr/local/opt
      system "make", "OSSLPATH=/opt/homebrew/opt/openssl@1.0"
    else
      system "make"
    end
    bin.install "chntpw"
  end

  test do
    assert_match "chntpw version 0.99.6 080526 (sixtyfour)", shell_output("#{bin}/chntpw -h")
  end
end
