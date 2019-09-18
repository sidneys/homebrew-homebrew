class ShairportSync < Formula
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
  depends_on "libsoxr"
  depends_on "openssl@1.1"
  depends_on "popt"
  depends_on "sidneys/homebrew/libalac"
  depends_on "sidneys/homebrew/pulseaudio"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-ao
      --with-apple-alac
      --with-dns_sd
      --with-metadata
      --with-os=darwin
      --with-pa
      --with-pipe
      --with-soxr
      --with-ssl=openssl
      --with-stdout
      --with-piddir=#{var}/run
      --sysconfdir=#{etc}/shairport-sync
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
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/shairport-sync</string>
        <string>--use-stderr</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>StandardErrorPath</key>
      <string>#{var}/log/#{name}.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/#{name}.log</string>
    </dict>
    </plist>
  EOS
  end

  def caveats
    <<~EOS
      `shairport-sync`s AirPlay audio synchronisation feature requires the `pulseaudio` sound system
      application to be active and running during usage.

      `pulseaudio` has already been installed as a Homebrew dependency. To run it unobstrusively in
      the background (recommended), start it as a service: `brew services start pulseaudio`
    EOS
  end

  test do
    assert_match "libdaemon-OpenSSL-dns_sd-ao-pa-stdout-pipe-soxr-convolution-metadata", shell_output("#{bin}/shairport-sync -V")
  end
end
