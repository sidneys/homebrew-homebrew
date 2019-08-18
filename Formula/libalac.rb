class Libalac < Formula
  desc "Apple Lossless Audio Codec (ALAC) Library"
  homepage "https://macosforge.github.io/alac/"
  url "https://github.com/sidneys/libalac/archive/v1.0.1.tar.gz"
  sha256 "e112299d519e9c3a3dbffd486c342c422d93e239c44a42410218a91d4f28753b"
  head "https://github.com/sidneys/libalac.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <assert.h>
      #include <alac/ALACEncoder.h>
      #include <alac/ALACDecoder.h>

      int main() {
        uint32_t   frameSize = kALACDefaultFramesPerPacket;
        uint8_t    *magicCookie = (uint8_t *)calloc(1337, 1);

        ALACEncoder *theEncoder = new ALACEncoder;
        theEncoder->SetFrameSize(frameSize);
        assert(theEncoder != NULL);

        ALACDecoder *theDecoder = new ALACDecoder;
        theDecoder->Init(magicCookie, 1337);
        assert(theDecoder != NULL);

        return 0;
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -lalac
    ]
    system ENV.cxx, testpath/"test.cpp", "-o", "test", *flags
    system "./test"
  end
end
