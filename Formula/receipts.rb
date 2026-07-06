class Receipts < Formula
  desc "Source-verified research at function-call latency. Agent-first CLI: every claim comes back with a source URL, quote, and verdict."
  homepage "https://github.com/treygoff24/receipts"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/receipts/releases/download/v0.2.1/receipts-aarch64-apple-darwin.tar.xz"
      sha256 "4e3cdbb8b92b41d1859969a47c17d78b53f3de024a9615cac215c310bf701a22"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/receipts/releases/download/v0.2.1/receipts-x86_64-apple-darwin.tar.xz"
      sha256 "a2e15ef37b6152a29d9aa7f7489f7e0f08ce46e6037aa8fe1d9ea7eecaec0255"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/receipts/releases/download/v0.2.1/receipts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1a40162becf633b94b0dfe78a28a10346c26d027f6318d7d1c967afbb160c9bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/receipts/releases/download/v0.2.1/receipts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e92f3ab4cb0b405d5eff04789c55a2c8825a074409fa436a297ab4c5f3f2925f"
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
