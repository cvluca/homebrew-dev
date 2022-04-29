class Qemu < Formula
  desc "qemu with iOS host support"
  homepage "http://www.qemu.org"
  url "https://github.com/utmapp/qemu/releases/download/v7.0.0-utm/qemu-7.0.0-utm.tar.bz2"
  sha256 "689f0204cfa999965fef8ec4df9f986bec9704aaf20aba60682646fb4ed27450"
  license "GPL-2.0-only"

  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "libssh"
  depends_on "libusb"
  depends_on "lzo"
  depends_on "ncurses"
  depends_on "nettle"
  depends_on "pixman"
  depends_on "snappy"
  depends_on "vde"


  def install
    ENV["LIBTOOL"] = "glibtool"

    args = %W[
      --prefix=#{prefix}
      --host=aarch64-apple-darwin
      --disable-debug-info
      --enable-shared-lib
      --disable-cocoa
      --cpu=aarch64
      --cross-prefix=
    ]
    system "./configure", *args
    system "make", "V=1", "install"
  end

  test do
    expected = build.stable? ? version.to_s : "QEMU Project"
    assert_match expected, shell_output("#{bin}/qemu-system-aarch64 --version")
  end
end
