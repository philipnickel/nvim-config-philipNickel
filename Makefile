.PHONY: install install-deps install-no-deps install-nvim backup clean help check-deps

# Default target
help:
	@echo "Available targets:"
	@echo "  install        - Full installation (backup + deps + config)"
	@echo "  install-no-deps - Install config only (skip dependencies)"
	@echo "  install-nvim   - Install/update neovim to latest version"
	@echo "  install-deps   - Install system dependencies (requires sudo)"
	@echo "  check-deps     - Check if dependencies are available"
	@echo "  backup         - Backup existing nvim config"
	@echo "  clean          - Remove nvim config and data"
	@echo "  help           - Show this help message"

# Full installation (installs user-space deps)
install: backup install-deps
	@echo "Installing nvim config..."
	git clone https://github.com/philipnickel/nvim-config-philipNickel.git ~/.config/nvim
	@echo "Installation complete! Run 'nvim' to start."

# Install without dependencies
install-no-deps: backup check-deps
	@echo "Installing nvim config (skipping dependencies)..."
	git clone https://github.com/philipnickel/nvim-config-philipNickel.git ~/.config/nvim
	@echo "Installation complete! Run 'nvim' to start."

# Install/update neovim to latest version
install-nvim:
	@echo "Installing latest neovim..."
	@mkdir -p ~/.local/bin
	@echo "Trying multiple download methods..."
	@if curl -L -o ~/.local/bin/nvim.appimage "https://github.com/neovim/neovim/releases/download/v0.10.2/nvim.appimage" && \
		chmod u+x ~/.local/bin/nvim.appimage && \
		~/.local/bin/nvim.appimage --version >/dev/null 2>&1; then \
		echo "AppImage method succeeded"; \
		ln -sf ~/.local/bin/nvim.appimage ~/.local/bin/nvim; \
	elif curl -L -o /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz" && \
		tar -xzf /tmp/nvim.tar.gz -C /tmp && \
		cp /tmp/nvim-linux64/bin/nvim ~/.local/bin/nvim && \
		chmod +x ~/.local/bin/nvim && \
		~/.local/bin/nvim --version >/dev/null 2>&1; then \
		echo "Tar.gz method succeeded"; \
		rm -f /tmp/nvim.tar.gz; \
		rm -rf /tmp/nvim-linux64; \
	else \
		echo "All download methods failed. Please install neovim manually."; \
		exit 1; \
	fi
	@ln -sf ~/.local/bin/nvim ~/.local/bin/nv
	@echo "Adding ~/.local/bin to PATH..."
	@if [ -f ~/.bashrc ]; then \
		grep -q 'export PATH="$$HOME/.local/bin:$$PATH"' ~/.bashrc || \
		echo 'export PATH="$$HOME/.local/bin:$$PATH"' >> ~/.bashrc; \
		echo "Updated ~/.bashrc"; \
	fi
	@if [ -f ~/.zshrc ]; then \
		grep -q 'export PATH="$$HOME/.local/bin:$$PATH"' ~/.zshrc || \
		echo 'export PATH="$$HOME/.local/bin:$$PATH"' >> ~/.zshrc; \
		echo "Updated ~/.zshrc"; \
	fi
	@echo "Neovim installed to ~/.local/bin/nvim"
	@echo "Alias 'nv' created for quick access"
	@echo "Run: source ~/.bashrc (or restart terminal)"
	@~/.local/bin/nvim --version | head -1

# Install user-space dependencies (no sudo required)
install-deps:
	@echo "Installing user-space dependencies..."
	@mkdir -p ~/.local/bin
	@echo "Installing ripgrep..."
	@if ! command -v rg >/dev/null 2>&1; then \
		curl -L https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz | \
		tar xz --strip-components=1 -C ~/.local/bin ripgrep-14.1.1-x86_64-unknown-linux-musl/rg; \
	fi
	@echo "Installing fd..."
	@if ! command -v fd >/dev/null 2>&1; then \
		curl -L https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-musl.tar.gz | \
		tar xz --strip-components=1 -C ~/.local/bin fd-v10.2.0-x86_64-unknown-linux-musl/fd; \
	fi
	@echo "Installing tree-sitter..."
	@if ! command -v tree-sitter >/dev/null 2>&1; then \
		curl -L https://github.com/tree-sitter/tree-sitter/releases/download/v0.24.4/tree-sitter-linux-x64.gz | \
		gunzip > ~/.local/bin/tree-sitter && chmod +x ~/.local/bin/tree-sitter; \
	fi
	@echo "User-space dependencies installed (git/curl assumed available)"
	@echo "Note: Some image plugins may not work without ImageMagick (requires admin)"

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