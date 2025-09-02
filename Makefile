.PHONY: install install-deps backup clean help

# Default target
help:
	@echo "Available targets:"
	@echo "  install      - Full installation (backup + deps + config)"
	@echo "  install-deps - Install system dependencies"
	@echo "  backup       - Backup existing nvim config"
	@echo "  clean        - Remove nvim config and data"
	@echo "  help         - Show this help message"

# Full installation
install: backup install-deps
	@echo "Installing nvim config..."
	git clone https://github.com/philipnickel/nvim-config-philipNickel.git ~/.config/nvim
	@echo "Installation complete! Run 'nvim' to start."

# Install system dependencies
install-deps:
	@echo "Installing system dependencies..."
	@if command -v apt > /dev/null; then \
		sudo apt update && \
		sudo apt install -y neovim git curl build-essential \
			imagemagick libmagickwand-dev liblua5.1-0-dev \
			luajit tree-sitter-cli ripgrep fd-find; \
	elif command -v yum > /dev/null; then \
		sudo yum install -y neovim git curl gcc-c++ make \
			ImageMagick ImageMagick-devel lua-devel \
			luajit luajit-devel ripgrep fd-find; \
	elif command -v dnf > /dev/null; then \
		sudo dnf install -y neovim git curl gcc-c++ make \
			ImageMagick ImageMagick-devel lua-devel \
			luajit luajit-devel ripgrep fd-find; \
	elif command -v pacman > /dev/null; then \
		sudo pacman -S --noconfirm neovim git curl base-devel \
			imagemagick lua luajit tree-sitter ripgrep fd; \
	else \
		echo "Unsupported package manager. Please install dependencies manually."; \
		exit 1; \
	fi

# Backup existing config
backup:
	@echo "Backing up existing nvim config..."
	@if [ -d ~/.config/nvim ]; then \
		mv ~/.config/nvim ~/.config/nvim.backup.$$(date +%Y%m%d_%H%M%S); \
		echo "Existing config backed up"; \
	fi
	@if [ -d ~/.local/share/nvim ]; then \
		mv ~/.local/share/nvim ~/.local/share/nvim.backup.$$(date +%Y%m%d_%H%M%S); \
		echo "Existing nvim data backed up"; \
	fi

# Clean installation
clean:
	@echo "Removing nvim config and data..."
	rm -rf ~/.config/nvim
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim
	rm -rf ~/.cache/nvim
	@echo "Clean complete"