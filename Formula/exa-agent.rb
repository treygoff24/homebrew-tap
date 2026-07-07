class ExaAgent < Formula
  desc "Agent-first CLI over the full Exa API surface (single static binary)"
  homepage "https://github.com/treygoff24/exa-agent-cli"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.2.0/exa-agent-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3597ba26f46c0e8c0a7b0093a314a5790664bd57095969265dc71ef12da260d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.2.0/exa-agent-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5522f540367a68d70ceacd21d456c5e5dd2682e0fe96c35d4f69286e016ceb1d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.2.0/exa-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2a7264b685045d18a7c4643d38dffef8589ed8017a4bb8d4b9c86417acc1fd83"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.2.0/exa-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "91631aa2e2fc061f8f14e88af9c94452de7b3b61f972ecbd1600c5328e34aeb0"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
