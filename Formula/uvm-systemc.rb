class UvmSystemc < Formula
  desc "Universal Verification Methodology (UVM) in SystemC"
  homepage "https://github.com/ezchi/uvm-systemc"
  url "https://github.com/ezchi/uvm-systemc.git", :tag => "1.0-beta2-cmake-4", :revision => "b677c7e9776afff8d6b91f3437a5da0152ee2c91"
  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "ezchi/homebrew-missingpiece/systemc" => :build

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
