class YoutubeDlc < Formula
  desc "Fork of youtube-dl with the intention of getting features tested by the community merged in the tool faster"
  homepage "https://github.com/blackjack4494/yt-dlc"
  head "https://github.com/blackjack4494/yt-dlc.git"
  license "Unlicense"

  depends_on "pandoc" => :build

  bottle :unneeded

  def install
    system "make", "PREFIX=#{prefix}" if build.head?
    bin.install "youtube-dlc"
    man1.install "youtube-dlc.1"
    bash_completion.install "youtube-dlc.bash-completion"
    zsh_completion.install "youtube-dlc.zsh" => "_youtube-dlc"
    fish_completion.install "youtube-dlc.fish"
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dlc", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dlc", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
