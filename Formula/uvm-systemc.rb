class UvmSystemc < Formula
  desc "Universal Verification Methodology (UVM) in SystemC"
  homepage "https://github.com/ezchi/uvm-systemc"
  url "https://github.com/ezchi/uvm-systemc/archive/refs/tags/1.0-beta5-cmake-1.tar.gz"
  sha256 "38a51d3aa600b164cebcd95999c2a186863741ca00d1f5642dd179fe42b42793"

  bottle do
    root_url "https://github.com/ezchi/homebrew-missingpiece/raw/master/Bottles"
    sha256 cellar: :any_skip_relocation, catalina: "971caf61374c88dc7010b5f0b741597fda79e68aea5f2df276594b15dea7c0a0"
  end

  depends_on "cmake" => :build
  depends_on "ezchi/homebrew-missingpiece/systemc" => :build
  depends_on "llvm" => :build

  def install
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix
    ENV["SYSTEMC_HOME"] = Formula["ezchi/homebrew-missingpiece/systemc"].prefix
    system "cmake", "-Brelease", "-H.",
           "-DCMAKE_INSTALL_PREFIX=#{prefix}",
           "-DBUILD_SOURCE_DOCUMENTATION=ON",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DCMAKE_CXX_COMPILER=clang++"
    system "cmake", "--build", "release", "--target", "install"
  end
end
