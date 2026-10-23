class Lens < Formula
  desc "Agent-first CLI for natural-language image-library search: caption once with Cerebras vision, then search the whole index in one model call."
  homepage "https://github.com/treygoff24/lens"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/lens/releases/download/v0.1.3/lens-cli-aarch64-apple-darwin.tar.xz"
      sha256 "343ddda4fd3e32e3145ad7e08935fad722fae292a21a93c6bcbe75bd8698501e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/lens/releases/download/v0.1.3/lens-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ff9a539a322908f5a8abeef320b14a9a62d93ec5539f86c9eb5a45e3ddec5e8d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/lens/releases/download/v0.1.3/lens-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d5ac2ae0b4464e02e9d4422d633b995a062a0ac43833f8d52735fc4f5b852af5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/lens/releases/download/v0.1.3/lens-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f98dcf542cbf573146ed58cb091efaead0ec71388deb2de6b558c6d2739f8cf5"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
      bin.install "lens"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "lens"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "lens"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "lens"
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
