class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "https://github.com/ezchi/systemc"
  url "https://github.com/ezchi/systemc.git", :tag => "v2.3.3", :revision => "e30ff935206887c35c81de837e244537fb3188d7"
  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build

  def install
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix
    system "cmake", "-Brelease", "-H.",
           "-DCMAKE_INSTALL_PREFIX=#{prefix}",
           "-DBUILD_SOURCE_DOCUMENTATION=ON",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DDISABLE_COPYRIGHT_MESSAGE=ON",
           "-DENABLE_ASSERTIONS=ON",
           "-DCMAKE_CXX_STANDARD=14",
           "-DCMAKE_CXX_STANDARD_REQUIRED=ON",
           "-DENABLE_PHASE_CALLBACKS=ON",
           "-DENABLE_PHASE_CALLBACKS_TRACING=OFF",
           "-DENABLE_PTHREADS=ON",
           "-DENABLE_EARLY_MAXTIME_CREATION=OFF",
           "-DCMAKE_CXX_COMPILER=clang++"
    system "cmake", "--build", "release", "--target", "install"
  end
end
