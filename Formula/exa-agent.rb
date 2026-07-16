class ExaAgent < Formula
  desc "Agent-first CLI over the full Exa API surface (single static binary)"
  homepage "https://github.com/treygoff24/exa-agent-cli"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.4.0/exa-agent-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0d00c383411d6800fd3c7fd89426095ecd535eb9ee42e3a5ae665d0570f77993"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.4.0/exa-agent-cli-x86_64-apple-darwin.tar.xz"
      sha256 "01e82309efda7bdf93440c1f752f7d11657085154976b2e91cac2f5967fe57e2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.4.0/exa-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2d3e1b725e4365411483c9fb88a7ce18df5a4836a05dd85de86d99feab49874b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/exa-agent-cli/releases/download/v0.4.0/exa-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0a583afb13821eba7e97da6650fc9a7e6f60672a181c03e5e0061a508a4cadf0"
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
