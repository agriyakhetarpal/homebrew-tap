# Builds Mirinae from source on the user's Mac. Locally built apps carry no quarantine flag,
# so there is no Gatekeeper prompt. Needs only the Command Line Tools Homebrew already requires.
class Mirinae < Formula
  desc "Galaxy Buds controls, diagnostics, and a menu bar panel"
  homepage "https://github.com/agriyakhetarpal/mirinae"
  url "https://github.com/agriyakhetarpal/mirinae/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "e71aaf97db288168629968559d8c69037a5c3e88b4cf940e79113674b8e21858"
  license "Apache-2.0"
  head "https://github.com/agriyakhetarpal/mirinae.git", branch: "main"

  depends_on macos: :sonoma

  def install
    # SwiftPM sandboxes manifest compilation, and that cannot nest inside Homebrew's sandbox.
    # 0.1.0 predates the SWIFT_BUILD_FLAGS passthrough in the build script, so patch it in.
    inreplace "Scripts/build-app.sh", "swift build ", "swift build --disable-sandbox "
    system "Scripts/build-app.sh", "release"
    prefix.install "build/Mirinae.app"
    bin.write_exec_script prefix/"Mirinae.app/Contents/MacOS/Mirinae"
  end

  def caveats
    <<~EOS
      Mirinae.app lives in #{prefix}. To add it to /Applications:
        cp -R #{prefix}/Mirinae.app /Applications/
      After upgrading, open the copy in /Applications once so its login items point at the new build.
    EOS
  end

  test do
    # 0.1.0 starts AppKit before answering --version, which aborts without a window server, so
    # check the bundle instead of running it.
    assert_match "<string>#{version}</string>", (prefix/"Mirinae.app/Contents/Info.plist").read
    assert_predicate prefix/"Mirinae.app/Contents/MacOS/Mirinae", :executable?
  end
end
