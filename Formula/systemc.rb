class Systemc < Formula
  desc "Mirror of Core SystemC language and examples"
  homepage "https://github.com/ezchi/systemc"
  url "https://github.com/accellera-official/systemc/archive/refs/tags/3.0.2.tar.gz"
  sha256 "9b3693ed286aab958b9e5d79bb0ad3bc523bbc46931100553275352038f4a0c4"

  bottle do
    sha256 cellar: :any, arm64_tahoe: "98e33e0fc1536b2281119619325735eae54de2fb0f3979da5756f09bc83917c5"
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
      -DCMAKE_CXX_STANDARD=17
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
    system ENV.cxx, "-std=c++17", "-L#{lib}", "-lsystemc", "test.cpp"
    system "./a.out"
  end
end
