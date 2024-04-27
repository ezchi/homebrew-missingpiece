class Systemc < Formula
  desc "Library of SystemC Class"
  homepage "https://github.com/ezchi/systemc-official"
  url "https://github.com/ezchi/systemc-official/archive/refs/tags/v3.0.1-ec.tar.gz"
  sha256 "f9509be592ddca6629d98e23b91712446fc1a018d54048df14a8f83dbdda42c8"
  head "https://github.com/ezchi/systemc-official.git", branch: "develop"

  bottle do
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

    # ENV.append "CXXFLAGS", "-stdlib=libc++" if ENV.compiler == :clang
    # ENV.append_to_cflags "-stdlib=libc++" if ENV.compiler == :clang
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
