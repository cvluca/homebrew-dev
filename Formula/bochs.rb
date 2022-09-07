class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "https://bochs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/2.7/bochs-2.7.tar.gz"
  sha256 "a010ab1bfdc72ac5a08d2e2412cd471c0febd66af1d9349bc0d796879de5b17a"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/bochs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "sdl2"
  depends_on "libxrandr"
  depends_on "libxpm"
  depends_on "wxwidgets"
  depends_on "gtk+3"

  uses_from_macos "ncurses"

  patch do
    # url "https://raw.githubusercontent.com/cvluca/homebrew-dev/master/patches/bochs_macos.patch"
    url "https://raw.githubusercontent.com/cvluca/homebrew-dev/bochs/patches/bochs_macos2.patch"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-docbook
      --enable-a20-pin
      --enable-alignment-check
      --enable-all-optimizations
      --enable-avx
      --enable-evex
      --enable-cdrom
      --enable-clgd54xx
      --enable-cpu-level=6
      --enable-debugger
      --enable-debugger-gui
      --enable-disasm
      --enable-fast-function-calls
      --enable-fpu
      --enable-iodebug
      --enable-large-ramfile
      --enable-logging
      --enable-long-phy-address
      --enable-pci
      --enable-plugins
      --enable-readline
      --enable-show-ips
      --enable-usb
      --enable-vmx=2
      --enable-x86-64
      --with-x11
      --with-wx
      --with-nogui
      --with-sdl2
      --with-term
    ]

    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    require "open3"

    (testpath/"bochsrc.txt").write <<~EOS
      panic: action=fatal
      error: action=report
      info: action=ignore
      debug: action=ignore
      display_library: nogui
    EOS

    expected = <<~EOS
      Bochs is exiting with the following message:
      \[BIOS  \] No bootable device\.
    EOS

    command = "#{bin}/bochs -qf bochsrc.txt"

    # When the debugger is enabled, bochs will stop on a breakpoint early
    # during boot. We can pass in a command file to continue when it is hit.
    (testpath/"debugger.txt").write("c\n")
    command << " -rc debugger.txt"

    _, stderr, = Open3.capture3(command)
    assert_match(expected, stderr)
  end
end
