class Receipts < Formula
  desc "Source-verified research at function-call latency. Agent-first CLI: every claim comes back with a source URL, quote, and verdict."
  homepage "https://github.com/treygoff24/receipts"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/receipts/releases/download/v0.3.1/receipts-aarch64-apple-darwin.tar.xz"
      sha256 "02b2857db57bf9613be7764c90a1376e3b5a188d639f19c42a853cc8d66c06b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/receipts/releases/download/v0.3.1/receipts-x86_64-apple-darwin.tar.xz"
      sha256 "2c10774346fa4073d52262fb55b23bf5b89434ddf1cee6ade03c9fe04dfd9bea"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/receipts/releases/download/v0.3.1/receipts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4e5c78ef297fa6466c9c9918178e991c8eccea964637054e6f09d3c8d175577e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/receipts/releases/download/v0.3.1/receipts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9ba4a61e6d54b186378b1238ca5d6e809011ee9a4bdee06b81cc6f1da5a78833"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "receipts"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "receipts"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "receipts"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "receipts"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
