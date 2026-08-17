{config, ...}: {
  imports = [./configuration.nix];

  home-manager.users.${config.meta.mainUser.username}.imports = [./home.nix];
}
