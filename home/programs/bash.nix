{ osConfig, ... }: {
  programs.bash = {
    enable = true;

    sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      NVM_DIR = "$HOME/.nvm";
    };

    shellAliases = {
      cnx = "nvim /etc/nixos/";
      # Build whichever host this machine actually is, derived from its
      # NixOS hostname, so `mnx` never rebuilds the wrong host's config.
      mnx = "sudo nixos-rebuild switch --flake /etc/nixos#${osConfig.networking.hostName} --impure";
      nfu = "sudo nix flake update";
    };

    initExtra = ''
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };
}
