class ZitaResampler < Formula
  desc "C++ library for resampling audio signals"
  homepage "http://kokkinizita.linuxaudio.org/linuxaudio/"
  url "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-resampler-1.6.0.tar.bz2"
  sha256 "10888d76299d8072990939be45d6fc5865f5a45d766d7690819c5899d2a588f0"

  depends_on "libsndfile"
  depends_on "coreutils" => :build

  def install
    ENV.prepend "PATH", Formula["coreutils"].libexec/"gnubin" + ":"

    cd "libs" do
      inreplace "Makefile", "-Wl,-soname,$(ZITA-RESAMPLER_MAJ)", ""
      inreplace "Makefile", "ldconfig", ""
      system "make", "install", "PREFIX=#{prefix}", "SUFFIX=", "ZITA-RESAMPLER_SO=libzita-resampler.dylib", "ZITA-RESAMPLER_MIN=libzita-resampler.#{version}.dylib"
    end

    ENV.append_to_cflags "-I#{include}"
    cd "apps" do
      mkdir share
      mkdir man
      mkdir bin
      inreplace "Makefile", "-lrt", ""
      system "make", "install", "PREFIX=#{prefix}", "SUFFIX=", "MANDIR=#{man}"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/zresample --help 2>&1", 1)
  end
end
