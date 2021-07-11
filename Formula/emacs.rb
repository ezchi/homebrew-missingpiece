class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  license "GPL-3.0-or-later"
  version "28.0.50"

  #
  # Options
  #

  # Opt-in
  option "with-native-comp", "Build from feature/native-comp branch"

  #
  # Dependencies
  #

  depends_on "autoconf" => :build
  depends_on "dbus" => :optional
  depends_on "fontconfig" => :recommended
  depends_on "freetype" => :recommended
  depends_on "gcc" => :build
  depends_on "gmp" => :build
  depends_on "gnu-sed" => :build
  depends_on "gnutls"
  depends_on "imagemagick" => :recommended
  depends_on "jansson"
  depends_on "libgccjit" => :recommended
  depends_on "libjpeg" => :build
  depends_on "librsvg"
  depends_on "libxaw"
  depends_on "little-cms2"
  depends_on "mailutils" => :optional
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build

  #
  # URL
  #

  if build.with? "native-comp"
    url "https://github.com/emacs-mirror/emacs.git", :branch => "feature/native-comp"
  else
    url "https://github.com/emacs-mirror/emacs.git"
  end

  #
  # Patches
  #

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp
      --infodir=#{info}/emacs
      --prefix=#{prefix}
    ]

    args << "--with-xml2"
    args << "--with-gnutls"

    args << "--with-nativecomp" if build.with? "native-comp"

    if build.with? "native-comp"
      gcc_ver = Formula["gcc"].any_installed_version
      gcc_ver_major = gcc_ver.major
      gcc_lib="#{HOMEBREW_PREFIX}/lib/gcc/#{gcc_ver_major}"

      ENV.append "CFLAGS", "-I#{Formula["gcc"].include}"
      ENV.append "CFLAGS", "-I#{Formula["libgccjit"].include}"
      ENV.append "CFLAGS", "-I#{Formula["gmp"].include}"
      ENV.append "CFLAGS", "-I#{Formula["libjpeg"].include}"

      ENV.append "LDFLAGS", "-L#{gcc_lib}"
      ENV.append "LDFLAGS", "-I#{Formula["gcc"].include}"
      ENV.append "LDFLAGS", "-I#{Formula["libgccjit"].include}"
      ENV.append "LDFLAGS", "-I#{Formula["gmp"].include}"
      ENV.append "LDFLAGS", "-I#{Formula["libjpeg"].include}"
    end

    args <<
      if build.with? "dbus"
        "--with-dbus"
      else
        "--without-dbus"
      end

    # Note that if ./configure is passed --with-imagemagick but can't find the
    # library it does not fail but imagemagick support will not be available.
    # See: https://debbugs.gnu.org/cgi/bugreport.cgi?bug=24455
    args <<
      if build.with?("imagemagick")
        "--with-imagemagick"
      else
        "--without-imagemagick"
      end

    if build.with? "imagemagick"
      imagemagick_lib_path = Formula["imagemagick"].opt_lib/"pkgconfig"
      ohai "ImageMagick PKG_CONFIG_PATH: ", imagemagick_lib_path
      ENV.prepend_path "PKG_CONFIG_PATH", imagemagick_lib_path
    end

    args << "--with-modules"
    args << "--with-rsvg"
    args << "--without-pop" if build.with? "mailutils"

    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
    system "./autogen.sh"

    # These libs are not specified in xft's .pc. See:
    # https://trac.macports.org/browser/trunk/dports/editors/emacs/Portfile#L74
    # https://github.com/Homebrew/homebrew/issues/8156
    ENV.append "LDFLAGS", "-lfreetype -lfontconfig"
    args << "--with-x"
    args << "--with-gif=no" << "--with-tiff=no" << "--with-jpeg=no"
    args << "--without-ns"

    system "./configure", *args

    # Disable aligned_alloc on Mojave. See issue: https://github.com/daviderestivo/homebrew-emacs-head/issues/15
    system "make"
    system "make", "install"

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    (bin/"ctags").unlink
    (man1/"ctags.1.gz").unlink
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end
