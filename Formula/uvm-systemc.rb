class UvmSystemc < Formula
  desc "Universal Verification Methodology (UVM) in SystemC"
  homepage "https://github.com/ezchi/uvm-systemc"
  url "https://github.com/ezchi/uvm-systemc/archive/refs/tags/1.0-beta5-cmake-1.tar.gz"
  sha256 "38a51d3aa600b164cebcd95999c2a186863741ca00d1f5642dd179fe42b42793"

  bottle do
    root_url "https://github.com/ezchi/homebrew-missingpiece/releases/download/uvm-systemc-1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "3c2fea72ba70407be1a67a944d8dee8a08e85e435932db7f522a61d317d83c33"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ezchi/homebrew-missingpiece/systemc" => :build
  depends_on "graphviz" => :build
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
