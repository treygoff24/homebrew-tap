class ExaAgent < Formula
  desc "Agent-first CLI over the full Exa API surface (single static binary)"
  homepage "https://github.com/treygoff24/exa-agent-cli"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.6.0/exa-agent-cli-aarch64-apple-darwin.tar.xz"
      sha256 "fd474e026d15fce6d7c2866badec7806403a01890544bfa43b28502f75c46bad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.6.0/exa-agent-cli-x86_64-apple-darwin.tar.xz"
      sha256 "11b2b1a6714ca07fe08494e719b6f0cdf98c32226a5f68e6b114d0fc1700f5d1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.6.0/exa-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a234ee35092b37086f65919ccf5f36aaca8e1e4d5d4babc0dca89b99c1e453ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.6.0/exa-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6b72e954f2ca2639d41c7ed69f955843c91872133e7ea7388ff4f863e9f14b37"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
      bin.install "exa-agent"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "exa-agent"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "exa-agent"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "exa-agent"
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
