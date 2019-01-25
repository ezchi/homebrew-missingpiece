class Ccls < Formula
  desc "C/C++ language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls.git", :tag => "0.20181225.7", :revision => "3810fb0a78d399a0a1916a1c59850b9b89f24b44"
  head "https://github.com/MaskRay/ccls.git"
  option "without-system-clang", "Downloading Clang from http://releases.llvm.org/ during the configure process"
  depends_on "cmake" => :build
  depends_on "llvm" => :build
  def install
    system_clang = build.with?("system-clang") ? "ON" : "OFF"
    args = std_cmake_args + %W[
      -DSYSTEM_CLANG=#{system_clang}
    ]
    ENV.prepend_path "PATH", Formula["llvm"].opt_bin
    if build.stable?
      ENV.append "LDFLAGS", "-lclangBasic"
    end
    mkdir_p "#{buildpath}/release"
    system "cmake", *args, "-Brelease", "-H." "-DCMAKE_BUILD_TYPE=Debug"
    system "cmake", "--build", "release", "--target", "install"
  end
  test do
    system "#{bin}/ccls", "--test-unit"
  end
end
