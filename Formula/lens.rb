class Lens < Formula
  desc "Agent-first CLI for natural-language image-library search: caption once with Cerebras vision, then search the whole index in one model call."
  homepage "https://github.com/treygoff24/lens"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/lens/releases/download/v0.1.1/lens-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0f52c23b5c17f355ff114a545455590f5bbf894e64cbcce700c8fcee8829e80c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/lens/releases/download/v0.1.1/lens-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f7d54320d5c73089b7f1bf5e68cf22d046d790480f8355fd82324e25409e3d8c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/lens/releases/download/v0.1.1/lens-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "43e1081491b2409656e9a595a7a9eb18a900ce7bd4a977b9e0d9b7f8c8b0bde2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/lens/releases/download/v0.1.1/lens-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "058cdfe8617a84a097711b99a716d64ff0ec77162208e15204040b05bb4c63cb"
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
    bin.install "lens" if OS.mac? && Hardware::CPU.arm?
    bin.install "lens" if OS.mac? && Hardware::CPU.intel?
    bin.install "lens" if OS.linux? && Hardware::CPU.arm?
    bin.install "lens" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
