class UvmSystemc < Formula
  desc "Universal Verification Methodology (UVM) in SystemC"
  homepage "https://github.com/ezchi/uvm-systemc"
  url "https://github.com/ezchi/uvm-systemc.git", :tag => "1.0-beta-cmake-2", :revision => "21c834fcf15f0ca5644b5c34c2ecbc2143c37d69"
  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "systemc" => :build

  def install
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix
    system "cmake", "-Brelease", "-H.",
           "-DCMAKE_INSTALL_PREFIX=#{prefix}",
           "-DBUILD_SOURCE_DOCUMENTATION=ON",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DCMAKE_CXX_COMPILER=clang++"
    system "cmake", "--build", "release", "--target", "install"
  end
end
