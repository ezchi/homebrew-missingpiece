class Ccls < Formula
  desc "C/C++ language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls.git", :tag => "0.20190823.5", :revision => "a655ca966d842e6111f5b4a28e6d6eeff84d96f4"
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
    system "cmake", *args, "-Brelease", "-H.", "-DCMAKE_BUILD_TYPE=Debug"
    system "cmake", "--build", "release", "--target", "install"
  end
  test do
    system "#{bin}/ccls", "--test-unit"
  end
end
