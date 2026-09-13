{ ... }: {
  # Module comes from the zen-browser flake, wired in via
  # home-manager.sharedModules in flake.nix.
  programs.zen-browser = {
    enable = true;

    # Sets BROWSER and adds mime associations, but only at mkDefault priority —
    # the explicit handlers in ../xdg.nix are what actually decide the default.
    setAsDefaultBrowser = true;

    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
    };
  };
}
