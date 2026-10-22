class Scout < Formula
  desc "Corpus hydration at retina speed — fast, cheap, hallucination-firewalled orientation for AI agents in any directory of code or documents."
  homepage "https://github.com/treygoff24/scout"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/scout/releases/download/v0.1.1/scout-cli-aarch64-apple-darwin.tar.xz"
      sha256 "875b5e101cc75b29c406b0155f202715a23f9c2b7402f9009dcea74e9188191d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/scout/releases/download/v0.1.1/scout-cli-x86_64-apple-darwin.tar.xz"
      sha256 "cca046884bf8c9858243b81a6e2d8ef671d94ed4b02729d59d0bc8eab6bd1a83"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/scout/releases/download/v0.1.1/scout-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a4b84af64ae00ae0e503ebade1f83da8e52ce305b2a85403bceaf85ec420eeea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/scout/releases/download/v0.1.1/scout-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "39ad23e6a44353181c5c21755faac320596c854a38d0aad0fb04c8eaa1f5cc29"
    end
  end
  license "Apache-2.0"

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
      bin.install "scout"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "scout"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "scout"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "scout"
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
