class ExaAgent < Formula
  desc "Agent-first CLI over the full Exa API surface (single static binary)"
  homepage "https://github.com/treygoff24/exa-agent-cli"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.7.0/exa-agent-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3acadaaca8046fe7735ef4acdcc48e6674bb0e7bc015e00170aab242acb50e58"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.7.0/exa-agent-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b764c6132507e6a21c3588821388838df454f7a30d82ff6fd21c4da33b1e5abd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.7.0/exa-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3e9383cbd384b7442a67fc44f87cd1a82aed19f50fa675a73e024b74f0e93ed8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.7.0/exa-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bad8e3a2f5cd909a445b60d1c1590780f6de2ea5aa0833d9a3ab6e6716538c1a"
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
