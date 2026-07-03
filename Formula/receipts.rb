class Receipts < Formula
  desc "Source-verified research at function-call latency. Agent-first CLI: every claim comes back with a source URL, quote, and verdict."
  homepage "https://github.com/treygoff24/receipts"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/receipts/releases/download/v0.1.1/receipts-aarch64-apple-darwin.tar.xz"
      sha256 "322ce5fcb0955e4a47d1e2fc63b07d230ce9c664c29fbc85f5f29280da36d9a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/receipts/releases/download/v0.1.1/receipts-x86_64-apple-darwin.tar.xz"
      sha256 "2af62c259b3b8ef0d5d94838a23a2363a1b42e8a7fbf1005120c48c3434734d0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/receipts/releases/download/v0.1.1/receipts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b3039e426543c12ba5b4f7eb7bcabeadb59f8eb52c53ac73f8496b763e2da7ab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/receipts/releases/download/v0.1.1/receipts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "03adb27ab274c7c9854c618e078cc530f1b6827c14b58c4ec4c144c5d3824624"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "receipts" if OS.mac? && Hardware::CPU.arm?
    bin.install "receipts" if OS.mac? && Hardware::CPU.intel?
    bin.install "receipts" if OS.linux? && Hardware::CPU.arm?
    bin.install "receipts" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
