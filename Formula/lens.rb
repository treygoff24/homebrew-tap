class Lens < Formula
  desc "Agent-first CLI for natural-language image-library search: caption once with Cerebras vision, then search the whole index in one model call."
  homepage "https://github.com/treygoff24/lens"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/lens/releases/download/v0.1.2/lens-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d28eb885bbeae6be18a0931744115e39a2e9753db0ac3fa9dd6f649c221c254a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/lens/releases/download/v0.1.2/lens-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3711af3ac3415c3f0bc7a56f218aba1e1955ef87a030c6e8a2e3168d3e23d7f7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/lens/releases/download/v0.1.2/lens-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "50350ba21caeeb8fac2cdef3dc6037b8fc65b219769b66e9d99335ff65547183"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/lens/releases/download/v0.1.2/lens-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4cbc1a6572b6fbfb8b16a96cf08f60b4721b2d901b3080fbd6325e57d9e68683"
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
