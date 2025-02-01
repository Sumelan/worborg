{
  inputs,
  lib,
  specialArgs,
  user ? "sumelan",
  ...
}@args:
let
  # provide an optional { pkgs } 2nd argument to override the pkgs
  mkNixosConfiguration =
    host:
    {
      pkgs ? args.pkgs,
    }:
    lib.nixosSystem {
      inherit pkgs;

      specialArgs = specialArgs // {
        inherit host user;
        isNixOS = true;
        isLaptop = host == "acer";
        isDesktop = host == "sakura";
        flake = "/home/${user}/projects/Wolborg";
      };

      modules = [
        ./${host} # host specific configuration
        ./${host}/hardware.nix # host specific hardware configuration
        ../system
        ../overlays
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = specialArgs // {
              inherit host user;
              isNixOS = true;
              isLaptop = host == "acer";
              isDesktop = host == "sakura";
              flake = "/home/${user}/projects/Wolborg";
            };

            users.${user} = {
              imports = [
                ./${host}/home.nix # host specific home-manager configuration
                ../home
              ];
            };
          };
        }
        # alias for home-manager
        (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ])
        inputs.agenix.nixosModules.default
      ];
    };
in
{
  acer = mkNixosConfiguration "acer" { };
  sakura = mkNixosConfiguration "sakura" { };
}
