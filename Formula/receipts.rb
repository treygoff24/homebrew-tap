class Receipts < Formula
  desc "Source-verified research at function-call latency. Agent-first CLI: every claim comes back with a source URL, quote, and verdict."
  homepage "https://github.com/treygoff24/receipts"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/receipts/releases/download/v0.3.0/receipts-aarch64-apple-darwin.tar.xz"
      sha256 "4cdd5581abb2f3f7021e104947b1d5704c5e3f4e9afa4399e631b580960b0f12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/receipts/releases/download/v0.3.0/receipts-x86_64-apple-darwin.tar.xz"
      sha256 "3d710890dbbecd764d635eb8f5b0e31c032edc4801698554da6b4b18b2ad015f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/receipts/releases/download/v0.3.0/receipts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "80e1524252f7903cd460ba6dfa6e6882b6d21d55db17013b335307aca40b5de3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/receipts/releases/download/v0.3.0/receipts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "13c6548708536b903ca209fd60cfb3cce1d06de8b1b5727cae743588078cc40d"
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
