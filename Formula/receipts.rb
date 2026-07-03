class Receipts < Formula
  desc "Source-verified research at function-call latency. Agent-first CLI: every claim comes back with a source URL, quote, and verdict."
  homepage "https://github.com/treygoff24/receipts"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/receipts/releases/download/v0.2.0/receipts-aarch64-apple-darwin.tar.xz"
      sha256 "98a657268f5fcb070535dc54c66ad7708704f6e8d9078421f67a06a2a386aae4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/receipts/releases/download/v0.2.0/receipts-x86_64-apple-darwin.tar.xz"
      sha256 "e843135119fe90a494c74a9871d7292a920fbb33b499a1e7063d0d2355021395"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/treygoff24/receipts/releases/download/v0.2.0/receipts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4713f0c955c9a2e7bdb9a10147215a9ff1649df9a84477d69913945afa918b36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/treygoff24/receipts/releases/download/v0.2.0/receipts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a4ee6daa8cdf6d47c7b4cd8c63feeba8bc837cc73d15c17092117faa9913e9ea"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
    bin.install "receipts" if OS.mac? && Hardware::CPU.arm?
    bin.install "receipts" if OS.mac? && Hardware::CPU.intel?
    bin.install "receipts" if OS.linux? && Hardware::CPU.arm?
    bin.install "receipts" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
