{ ... }: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "CaskaydiaCove Nerd Font:size=12";
        terminal = "ghostty";
        layer = "overlay";
        width = 50;
      };
      colors = {
        background = "191724ff";
        text = "e0def4ff";
        match = "ebbcbaff";
        selection = "1f1d2eff";
        selection-text = "e0def4ff";
        selection-match = "ebbcbaff";
        border = "c4a7e7ff";
      };
      border = {
        width = 2;
        radius = 6;
      };
    };
  };
}
