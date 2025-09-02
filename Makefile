.PHONY: install install-deps install-no-deps backup clean help check-deps

# Default target
help:
	@echo "Available targets:"
	@echo "  install        - Full installation (backup + deps + config)"
	@echo "  install-no-deps - Install config only (skip dependencies)"
	@echo "  install-deps   - Install system dependencies (requires sudo)"
	@echo "  check-deps     - Check if dependencies are available"
	@echo "  backup         - Backup existing nvim config"
	@echo "  clean          - Remove nvim config and data"
	@echo "  help           - Show this help message"

# Full installation (tries deps, continues without if fails)
install: backup
	@echo "Installing nvim config..."
	@if $(MAKE) install-deps 2>/dev/null; then \
		echo "Dependencies installed successfully"; \
	else \
		echo "Warning: Could not install dependencies (no sudo access?)"; \
		echo "You may need to ask your admin to install: neovim git curl build tools"; \
	fi
	git clone https://github.com/philipnickel/nvim-config-philipNickel.git ~/.config/nvim
	@echo "Installation complete! Run 'nvim' to start."

# Install without dependencies
install-no-deps: backup check-deps
	@echo "Installing nvim config (skipping dependencies)..."
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

# Check if dependencies are available
check-deps:
	@echo "Checking dependencies..."
	@command -v nvim >/dev/null 2>&1 || echo "❌ neovim not found"
	@command -v git >/dev/null 2>&1 || echo "❌ git not found"
	@command -v curl >/dev/null 2>&1 || echo "❌ curl not found"
	@command -v nvim >/dev/null 2>&1 && echo "✅ neovim found"
	@command -v git >/dev/null 2>&1 && echo "✅ git found" 
	@command -v curl >/dev/null 2>&1 && echo "✅ curl found"

# Clean installation
clean:
	@echo "Removing nvim config and data..."
	rm -rf ~/.config/nvim
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim
	rm -rf ~/.cache/nvim
	@echo "Clean complete"