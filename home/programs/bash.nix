{ ... }: {
  programs.bash = {
    enable = true;

    sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      NVM_DIR = "$HOME/.nvm";
    };

    shellAliases = {
      cnx = "nvim /etc/nixos/";
      mnx = "sudo nixos-rebuild switch --flake /etc/nixos#dbook --impure";
      cdwm = "nvim ~/workspace/dotfiles-wm/dwm/config.h";
    };

    initExtra = ''
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };
}
