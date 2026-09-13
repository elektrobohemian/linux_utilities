YELLOW='\033[0;33m'
NC='\033[0m' # No Color

printf "\n${YELLOW}Creating typical directories below home${NC}\n"


mkdir -p ~/temp
mkdir -p ~/src
mkdir -p ~/src/__datasets

printf "\n${YELLOW}Setting up typical tools (requires Homebrew)${NC}\n"
brew install fish
brew install starship
brew install duf
brew install htop
brew install nvtop
brew install ffmpeg
brew install tldr
brew install uv
brew install fastfetch
brew install yt-dlp
brew install --cask meld
brew install coreutils
brew install uninstallpkg

printf "\n${YELLOW}Shell configuration (requires starship)${NC}\n"

printf '\n#daz: starship.rs\nstarship init fish | source' >> ~/.config/fish/config.fish
curl --output ~/.config/starship.toml https://raw.githubusercontent.com/elektrobohemian/linux_utilities/refs/heads/main/starship.toml

printf "\n${YELLOW}Adding macOS standard .gitignore${NC}\n"
mkdir -p ~/.config/git
curl --output ~/.config/git/ignore https://raw.githubusercontent.com/elektrobohemian/linux_utilities/refs/heads/main/gitignore_macos

printf "\n${YELLOW}Setting standard shell to fish${NC}\n"
command -v fish | sudo tee -a /etc/shells
chsh -s "$(command -v fish)"

