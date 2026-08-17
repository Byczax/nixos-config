{config, ...}: {
  imports = [./configuration.nix];

  # Attach this host's home-manager config for the primary user.
  home-manager.users.${config.meta.mainUser.username}.imports = [./home.nix];
}
