class UvmSystemc < Formula
  desc "Universal Verification Methodology (UVM) in SystemC"
  homepage "https://github.com/ezchi/uvm-systemc"
  url "https://github.com/ezchi/uvm-systemc.git", :tag => "1.0-beta3-cmake-1", :revision => "042c031a5b0a387bd6753daffe6a6c5c8a317c8d"
  version "1.0-beta3-cmake-1"
  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "ezchi/homebrew-missingpiece/systemc" => :build

  bottle do
    root_url "https://github.com/ezchi/homebrew-missingpiece/raw/master/Bottles"
    sha256 "84d5256036ff7a74887ee738e433771f8f22d2e0c37efc69d8ed03a1f18776bf" => :catalina
  end

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
