class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "https://github.com/ezchi/systemc"
  url "https://github.com/ezchi/systemc.git", :tag => "v2.3.3", :revision => "e30ff935206887c35c81de837e244537fb3188d7"
  depends_on "cmake" => :build
  depends_on "llvm" => :build

  def install
    system "cmake", "-Brelease", "-H.", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "-DCMAKE_CXX_STANDARD=14", "-DCMAKE_CXX_STANDARD_REQUIRED=ON"
    system "cmake", "--build", "release", "--target", "install"
  end
end
