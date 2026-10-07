class ExaAgent < Formula
  desc "Agent-first CLI over the full Exa API surface (single static binary)"
  homepage "https://github.com/treygoff24/exa-agent-cli"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.8.0/exa-agent-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d5607f8c66d541a0f1a0662117866d42d2831c49174fa1de7bc9e91db84b9170"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.8.0/exa-agent-cli-x86_64-apple-darwin.tar.xz"
      sha256 "307b516de4ab5f44643c29eac6b3da816ba878934c3cc7e83e4fe7deea41b40d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.8.0/exa-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "930663a504aba1b691f34e1db9a884848cee91b26c388c8ad148e145c33b6c42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.8.0/exa-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b67e90fbf3d19a04be50f01695cd1abd90b6c797b14fcd2965ae99c0c5c077c9"
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
