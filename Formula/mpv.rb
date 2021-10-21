class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.33.1.tar.gz"
  sha256 "100a116b9f23bdcda3a596e9f26be3a69f166a4f1d00910d1789b6571c46f3a9"
  license :cannot_represent
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 arm64_big_sur: "dd487a80e5586c93ccde6942170d026e9eba5b403d95e409ad55282cea818790"
    sha256 big_sur:       "76b0fc9d207aee16f65b8b1782bc35dec5a870952ebba6ae7a74e6ede9bdd34a"
    sha256 catalina:      "8ab98fffc330dea03f2732fa17c7f53753601c49c3f9dec2a7d727bdc901c484"
    sha256 mojave:        "87df95e8f4f723a5b6fe163d5ac740fef9f5ffa9c318c82c9a6b0844aa7203b9"
  end

  option "with-bundle", "Enable compilation of the .app bundle."
  option "with-lgpl", "Build with LGPLv2.1 or later license"

  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on xcode: :build

  depends_on "sidneys/homebrew/ffmpeg"
  depends_on "jpeg"
  depends_on "libass"
  depends_on "little-cms2"
  depends_on "luajit-openresty"
  depends_on "mujs"
  depends_on "sidneys/homebrew/youtube-dl"

  depends_on "jack" => :optional
  depends_on "libaacs" => :optional
  depends_on "libarchive" => :optional
  depends_on "libbluray" => :optional
  depends_on "libcaca" => :optional
  depends_on "libdvdnav" => :optional
  depends_on "libdvdread" => :optional
  depends_on "pulseaudio" => :optional
  depends_on "rubberband" => :optional
  depends_on "uchardet" => :optional
  depends_on "vapoursynth" => :optional

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    # libarchive is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig" if build.with? "libarchive"
    # luajit-openresty is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["luajit-openresty"].opt_lib/"pkgconfig"

    args = %W[
      --prefix=#{prefix}
      --enable-html-build
      --enable-javascript
      --enable-libmpv-shared
      --enable-lua
      --disable-swift
      --confdir=#{etc}/mpv
      --datadir=#{pkgshare}
      --mandir=#{man}
      --docdir=#{doc}
      --zshdir=#{zsh_completion}
      --lua=luajit
    ]
    args << "--enable-libarchive" if build.with? "libarchive"
    args << "--enable-uchardet" if build.with? "uchardet"
    args << "--enable-libbluray" if build.with? "libbluray"
    args << "--enable-dvdnav" if build.with? "libdvdnav"
    args << "--enable-dvdread" if build.with? "libdvdread"
    args << "--enable-pulse" if build.with? "pulseaudio"
    args << "--enable-lgpl" if build.with? "lgpl"
    args << "--enable-jack" if build.with? "jack"

    system Formula["python@3.9"].opt_bin/"python3", "bootstrap.py"
    system Formula["python@3.9"].opt_bin/"python3", "waf", "configure", *args
    system Formula["python@3.9"].opt_bin/"python3", "waf", "install"

    if build.with? "bundle"
      system "python3", "TOOLS/osxbundle.py", "build/mpv"
      prefix.install "build/mpv.app"
    end
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
    assert_match "vapoursynth", shell_output(bin/"mpv --vf=help")
  end
end
