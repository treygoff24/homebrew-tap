class Receipts < Formula
  desc "Source-verified research at function-call latency. Agent-first CLI: every claim comes back with a source URL, quote, and verdict."
  homepage "https://github.com/treygoff24/receipts"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/receipts/releases/download/v0.1.0/receipts-aarch64-apple-darwin.tar.xz"
      sha256 "c90e02e8d15dbed009f08b352bda403e4643d5314ecc24f86d81ec3be600ce97"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/receipts/releases/download/v0.1.0/receipts-x86_64-apple-darwin.tar.xz"
      sha256 "e4db260363c3b4125e9df73269e7fc09860be07ab103ec401c2e3563f8be56e8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/receipts/releases/download/v0.1.0/receipts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f19b0506afb3a7bcdc512d43789213b9a49ce0f0d2c500d07e63c66812a5ace3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/receipts/releases/download/v0.1.0/receipts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "133d9182494a12405127317cb86c4c8a6fe76020ee1af0027c7e486aa402bae5"
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
