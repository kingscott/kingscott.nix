{ ... }: {
  services.mako = {
    enable = true;
    settings = {
      font = "CaskaydiaMono Nerd Font Mono 12";
      width = 320;
      height = 150;
      margin = "10";
      padding = "10";
      border-size = 2;
      border-radius = 4;
      default-timeout = 5000;
      background-color = "#1f1d2e";
      text-color = "#e0def4";
      border-color = "#c4a7e7";
      anchor = "top-right";
    };
  };
}
