# Nixos Configuration

This is Nixos configuration using flakes and home manager.

I try my best to make it clean and by the rules of nixos community.

## (r)agenix

`ykman piv reset` - if you don't care about the certificates that you already
have on the yubikey and get error when adding the agenix.

```bash
age-plugin-yubikey --generate

age-plugin-yubikey --identity > modules/system/secrets/yubikey-<ID>.pub

agenix rekey
```

## git-agecrypt

Once: `git-agecrypt init`

For single yubikey, example folder assets:

```bash
git-agecrypt config add -r "$(grep "age1" modules/system/secrets/yubikey-<ID>.pub | awk '{print $NF}')" -p assets/*
```

For multiple yubikeys:

```bash
rm -f git-agecrypt.toml
git-agecrypt config add -r "$(grep "age1" modules/system/secrets/yubikey-*.pub | awk '{print $NF}')" -p assets/*
```

You need to map your identity for git:

```bash
age-plugin-yubikey --identity > .git/yubikey-identity.txt
git-agecrypt config add -i .git/yubikey-identity.txt
```

Look into `.gitattributes` to learn how to add the files/folders

## TODO

Things that are annoying after loading fresh instance

- [ ] Logging back into all accounts
- [ ] Ability to store encrypted ssh keys in repository (forgot to back them up,
      idk if it's good idea)

Create hosts with different configurations (configuration.nix,
hardware-configuration.nix, home.nix) In modules directory, sort between nixos
and home manager modules
