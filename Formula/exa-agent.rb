class ExaAgent < Formula
  desc "Agent-first CLI over the full Exa API surface (single static binary)"
  homepage "https://github.com/treygoff24/exa-agent-cli"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.5.0/exa-agent-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8ccb5d89bb30d9a72967abc940e0b73a14243475cb7254e331de99053822b158"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.5.0/exa-agent-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a98c1442160545c2b272a0954250cdac7b1dae3bdc8a90e197c972896320d247"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.5.0/exa-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "20d720bebecb190a7e7bf0a68c835645333507e54722943b49e33bffb35a2ab3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.5.0/exa-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "020513ae11b62cf12894d529b3b4f689ae0a315ba56a0131cc520992317e79b0"
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
    bin.install "exa-agent" if OS.mac? && Hardware::CPU.arm?
    bin.install "exa-agent" if OS.mac? && Hardware::CPU.intel?
    bin.install "exa-agent" if OS.linux? && Hardware::CPU.arm?
    bin.install "exa-agent" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
