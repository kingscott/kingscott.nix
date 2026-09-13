{ ... }: {
  # Tell the desktop the preferred colour scheme is dark, once, so apps can
  # ask rather than each being themed by hand.
  #
  # xdg-desktop-portal-gtk (wired up in modules/niri.nix) reads this dconf key
  # and republishes it as the freedesktop org.freedesktop.appearance
  # color-scheme setting. Firefox, Trayscale and anything else GTK4/libadwaita,
  # Chromium- or Electron-based asks the portal for it and picks its own dark
  # variant. Nothing here sets fonts, icons or per-app colours.
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}
