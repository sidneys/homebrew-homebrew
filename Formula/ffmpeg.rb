class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-4.4.1.tar.xz"
  sha256 "eadbad9e9ab30b25f5520fbfde99fae4a92a1ae3c0257a8d68569a4651e30e02"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  # license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/FFmpeg/FFmpeg.git", branch: "master"

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "3f0fd439dab73037bf1577aeef75fe61693a8c7d231db15355685aa27d998503"
    sha256 arm64_big_sur:  "595897c60fd28be047977306a35e53fc6f6f29b021af7b0ee542719bf892eca4"
    sha256 monterey:       "d86a545fd61b459c1adafcec61bf1803f8f632fe527a88682af4fb89c37056fd"
    sha256 big_sur:        "b3e866d21b8a51653e294e08c8be65e5095894f52f6cb6b914025992191c1c50"
    sha256 catalina:       "ea2431a650ae91eb8ea197d7e1d8e82f50d5dfdaad08a0da7c067609e8b1922f"
    sha256 x86_64_linux:   "a91fa175c2f2a47c9afd240bf2cf97064b14647077be5804da159b6a4244fe62"
  end

  # FFmpeg Build Options: Switches
  option "with-chromaprint", "Enable the Chromaprint audio fingerprinting library"
  option "with-decklink", "Enable decklink support"
  option "with-fdk-aac", "Enable the Fraunhofer FDK AAC library"
  option "with-game-music-emu", "Enable game-music-emu library"
  option "with-libbs2b", "Enable libbs2b library"
  option "with-libcaca", "Enable libcaca library"
  option "with-libgsm", "Enable libgsm library"
  option "with-libmodplug", "Enable libmodplug library"
  option "with-librsvg", "Enable SVG files as inputs via librsvg"
  option "with-libssh", "Enable SFTP protocol via libssh"
  option "with-libvmaf", "Enable libvmaf scoring library"
  option "with-openh264", "Enable OpenH264 library"
  option "with-openssl", "Enable SSL support"
  option "with-two-lame", "Enable two-lame library"
  option "with-zeromq", "Enable using libzeromq to receive cmds sent through a libzeromq client"
  option "with-zimg", "Enable z.lib zimg library"

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "aom"
  depends_on "dav1d"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "frei0r"
  depends_on "gnutls"
  depends_on "lame"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "librist"
  depends_on "libsoxr"
  depends_on "libvidstab"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opencore-amr"
  depends_on "openjpeg"
  depends_on "opus"
  depends_on "rav1e"
  depends_on "rubberband"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "speex"
  depends_on "srt"
  depends_on "tesseract"
  depends_on "theora"
  depends_on "webp"
  depends_on "x264"
  depends_on "x265"
  depends_on "xvid"
  depends_on "xz"

  # FFmpeg Build Options: Add Dependencies
  depends_on "fdk-aac" => :optional
  depends_on "game-music-emu" => :optional
  depends_on "libbs2b" => :optional
  depends_on "libcaca" => :optional
  depends_on "libgsm" => :optional
  depends_on "libmodplug" => :optional
  depends_on "librsvg" => :optional
  depends_on "libssh" => :optional
  depends_on "libvmaf" => :optional
  depends_on "openh264" => :optional
  depends_on "openssl" => :optional
  depends_on "two-lame" => :optional
  depends_on "zeromq" => :optional
  depends_on "zimg" => :optional

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libxv"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-version3
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-ffplay
      --disable-gnutls
      --enable-gpl
      --enable-libaom
      --enable-libbluray
      --enable-libdav1d
      --enable-libmp3lame
      --enable-libopus
      --enable-librav1e
      --enable-librist
      --enable-librubberband
      --enable-libsnappy
      --enable-libsrt
      --enable-libtesseract
      --enable-libtheora
      --enable-libvidstab
      --enable-libvorbis
      --enable-libvpx
      --enable-libwebp
      --enable-libx264
      --enable-libx265
      --enable-libxml2
      --enable-libxvid
      --enable-lzma
      --enable-libfontconfig
      --enable-libfreetype
      --enable-frei0r
      --enable-libass
      --enable-libopencore-amrnb
      --enable-libopencore-amrwb
      --enable-libopenjpeg
      --enable-libspeex
      --enable-libsoxr
      --disable-libjack
      --disable-indev=jack
      --enable-demuxer=dash
      --disable-htmlpages
      --enable-nonfree
    ]

    # libavresample has been deprecated and removed but some non-updated formulae are still linked to it
    # Remove in the next release
    args << "--enable-avresample" unless build.head?

    # Needs corefoundation, coremedia, corevideo
    args << "--enable-videotoolbox" if OS.mac?

    # Needs macOS
    args << "--enable-audiotoolbox" if OS.mac?
    args << "--enable-opencl" if OS.mac?

    # FFmpeg Compilation Options: Set Options
    args << "--enable-chromaprint" if build.with? "chromaprint"
    args << "--enable-libfdk-aac" if build.with? "fdk-aac"
    args << "--enable-libgme" if build.with? "game-music-emu"
    args << "--enable-libbs2b" if build.with? "libbs2b"
    args << "--enable-libcaca" if build.with? "libcaca"
    args << "--enable-libgsm" if build.with? "libgsm"
    args << "--enable-libmodplug" if build.with? "libmodplug"
    args << "--enable-librsvg" if build.with? "librsvg"
    args << "--enable-libssh" if build.with? "libssh"
    args << "--enable-libvmaf" if build.with? "libvmaf"
    args << "--enable-libopenh264" if build.with? "openh264"
    args << "--enable-openssl" if build.with? "openssl"
    args << "--enable-libtwolame" if build.with? "two-lame"
    args << "--enable-libzmq" if build.with? "zeromq"
    args << "--enable-libzimg" if build.with? "zimg"

    # DeckLink
    if build.with? "decklink"
      args << "--enable-decklink"
      args << "--extra-cflags=-I#{HOMEBREW_PREFIX}/include"
      args << "--extra-ldflags=-L#{HOMEBREW_PREFIX}/include"
    end

    # TODO: Hotfix, macOS Compilation requires metal library
    args << "--disable-filter=yadif_videotoolbox" if OS.mac?

    # Replace hardcoded default VMAF model path
    %w[doc/filters.texi libavfilter/vf_libvmaf.c].each do |f|
      inreplace f, "/usr/local/share/model", HOMEBREW_PREFIX/"share/libvmaf/model"
      # Since libvmaf v2.0.0, `.pkl` model files have been deprecated in favor of `.json` model files.
      inreplace f, "vmaf_v0.6.1.pkl", "vmaf_v0.6.1.json"
    end

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }

    # Fix for Non-executables that were installed to bin/
    mv bin/"python", pkgshare/"python", force: true
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
