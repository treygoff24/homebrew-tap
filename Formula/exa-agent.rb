class ExaAgent < Formula
  desc "Agent-first CLI over the full Exa API surface (single static binary)"
  homepage "https://github.com/treygoff24/exa-agent-cli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.1.0/exa-agent-cli-aarch64-apple-darwin.tar.xz"
      sha256 "08124f2b72cd7ea2dbd74a2d283f1d93a1ef5621ccd6757ea50e22b41b9ca355"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.1.0/exa-agent-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c08a6078507708668d0d95ee08a5f947004d71acaf0994e7a12037677d2889c6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.1.0/exa-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ed4f8738de047d44ff10abc5cc12ac27aa38e467f966611bb0826cd742033f75"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.1.0/exa-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "639258dd7d1d42c3b17dc381b8abf0a9bff94708f01149f3a8e222531d5a0183"
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
