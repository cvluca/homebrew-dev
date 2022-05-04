class Swtpm < Formula
  desc "Software TPM Emulator based on libtpms"
  homepage "https://github.com/stefanberger/swtpm"
  url "https://github.com/stefanberger/swtpm/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "e856d1f5842fb3335164f02f2c545dd329efbc3416db20b7a327e991a4cd49c8"
  license "BSD-3-Clause"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "json-glib" => :build
  depends_on "socat" => :build
  depends_on "libtpms"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libtasn1"
  depends_on "openssl@3"

  def install
    system "./autogen.sh", "--prefix=#{prefix}", "--with-openssl"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"swtpm", "--version"
  end
end
