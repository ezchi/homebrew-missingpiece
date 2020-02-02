class UvmSystemc < Formula
  desc "Universal Verification Methodology (UVM) in SystemC"
  homepage "https://github.com/ezchi/uvm-systemc"
  url "https://github.com/ezchi/uvm-systemc.git", :tag => "1.0-beta-cmake-2", :revision => "0f288104533a409f9c01d3d34bc69c0e32f7186c"
  depends_on "cmake" => :build
  depends_on "llvm" => :build

  def install
    system "cmake", "-Brelease", "-H.", "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "cmake", "--build", "release", "--target", "install"
  end
end
