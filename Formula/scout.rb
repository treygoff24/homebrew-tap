class Scout < Formula
  desc "Corpus hydration at retina speed — fast, cheap, hallucination-firewalled orientation for AI agents in any directory of code or documents."
  homepage "https://github.com/treygoff24/scout"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/scout/releases/download/v0.1.0/scout-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4bdd5b138818049fae29c0f1f3136c8fff9d4791310463f9f3489687481181cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/scout/releases/download/v0.1.0/scout-cli-x86_64-apple-darwin.tar.xz"
      sha256 "69e9a1279a0be45fcf08358cd7ec476fd7994f2468e6312e905783e669994bd0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/scout/releases/download/v0.1.0/scout-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4e5abe230969a6c52d6cbf38d14581bf4c339a19bbb82302be67d744e5b055a1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/scout/releases/download/v0.1.0/scout-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d76c7b3f8f52bf5fcd9801cadf8f92a08bf54f1405befd3da09198d55eef9c51"
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
    bin.install "scout" if OS.mac? && Hardware::CPU.arm?
    bin.install "scout" if OS.mac? && Hardware::CPU.intel?
    bin.install "scout" if OS.linux? && Hardware::CPU.arm?
    bin.install "scout" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
