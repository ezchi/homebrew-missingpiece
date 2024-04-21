class Systemc < Formula
  desc "Mirror of Core SystemC language and examples"
  homepage "https://github.com/ezchi/systemc"
  url "https://github.com/accellera-official/systemc/archive/refs/tags/3.0.0.tar.gz"
  sha256 "4d0ab814719cfd6b1d195dd4bcb1b9e6edc5881b9a3e44117336a691992bf779"

  bottle do
    root_url "https://github.com/ezchi/homebrew-missingpiece/releases/download/systemc-2.3.3"
    rebuild 1
    sha256 catalina: "50ae697758703a513d395e5dd87fb210ca3b622c09a43460f1c8b3744f0737da"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "llvm" => :build

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DBUILD_SOURCE_DOCUMENTATION=ON
      -DCMAKE_BUILD_TYPE=Release
      -DDISABLE_COPYRIGHT_MESSAGE=ON
      -DENABLE_ASSERTIONS=ON
      -DCMAKE_CXX_STANDARD=14
      -DCMAKE_CXX_STANDARD_REQUIRED=ON
      -DENABLE_PTHREADS=ON
    ]

    ENV.append "CXXFLAGS", "-stdlib=libc++" if ENV.compiler == :clang
    ENV.append_to_cflags "-stdlib=libc++" if ENV.compiler == :clang
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib # but link against system libc++
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix

    system "cmake", "-Brelease", "-H.", *args
    system "cmake", "--build", "release", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "systemc.h"

      int sc_main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "-L#{lib}", "-lsystemc", "test.cpp"
    system "./a.out"
  end
end
