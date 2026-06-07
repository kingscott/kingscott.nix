{ config, ... }:
let
  link = file:
    config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/programs/noctalia/${file}";
in
{
  xdg.configFile."noctalia/settings.json".source = link "settings.json";
  xdg.configFile."noctalia/colors.json".source = link "colors.json";
  xdg.configFile."noctalia/plugins.json".source = link "plugins.json";
}
