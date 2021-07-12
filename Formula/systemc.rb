class Systemc < Formula
  desc "Mirror of Core SystemC language and examples"
  homepage "https://github.com/ezchi/systemc"
  url "https://github.com/ezchi/systemc.git", tag: "v2.3.3", revision: "e30ff935206887c35c81de837e244537fb3188d7"

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
      -DENABLE_PHASE_CALLBACKS=ON
      -DENABLE_PHASE_CALLBACKS_TRACING=OFF
      -DENABLE_PTHREADS=ON
      -DENABLE_EARLY_MAXTIME_CREATION=OFF
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
