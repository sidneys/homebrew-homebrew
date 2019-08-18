class ShairportSyncPulseaudio < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/3.3.2.tar.gz"
  sha256 "a8f580fa8eb71172f6237c0cdbf23287b27f41f5399f5addf8cd0115a47a4b2b"
  head "https://github.com/mikebrady/shairport-sync.git", :branch => "development"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "openssl"
  depends_on "popt"
  depends_on "sidneys/homebrew/libalac"
  depends_on "sidneys/homebrew/pulseaudio"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-os=darwin
      --with-ssl=openssl
      --with-dns_sd
      --with-ao
      --with-pa
      --with-convolution
      --with-apple-alac
      --with-libdaemon
      --with-stdout
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{home}/Library/Application Support/#{name}
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  plist_options :manual => "shairport-sync"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <dict>
        <key>OtherJobActive</key>
        <dict>
          <key>homebrew.mxcl.pulseaudio</key>
          <true/>
        </dict>
        <key>OtherJobEnabled</key>
        <dict>
          <key>homebrew.mxcl.pulseaudio</key>
          <true/>
        </dict>
      </dict>
      <key>ProgramArguments</key>
      <array>
        <string>#{bin}/shairport-sync</string>
      </array>
      <key>StandardErrorPath</key>
      <string>#{home}/Library/Logs/#{name}.log</string>
      <key>StandardOutPath</key>
      <string>#{home}/Library/Logs/#{name}.log</string>
    </dict>
    </plist>
  EOS
  end

  test do
    assert_match "libdaemon-OpenSSL-dns_sd-ao-pa-stdout-pipe-soxr-convolution-metadata", shell_output("#{bin}/shairport-sync -V")
  end
end