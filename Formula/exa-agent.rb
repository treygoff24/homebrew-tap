class ExaAgent < Formula
  desc "Agent-first CLI over the full Exa API surface (single static binary)"
  homepage "https://github.com/treygoff24/exa-agent-cli"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.8.1/exa-agent-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8f1c768f36cf6a7a3e32b6f82c7ee20c5a02d2bb8d4806ce0dd9113c9a9f6562"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.8.1/exa-agent-cli-x86_64-apple-darwin.tar.xz"
      sha256 "27cef48995fdbdb1a0d787ae71a5c8541e64748c41e886060e14195be057fe6b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.8.1/exa-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5ce8e6c0fc3e3fb1de2c4551441924518df64fbde938e68f6d4f2efcbb6203d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.8.1/exa-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "44fd096063b0bc23c9c272b2dbe77829742375a5f3a1020329e8191bce83e4d2"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
