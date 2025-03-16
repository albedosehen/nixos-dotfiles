{ inputs, ...}: {
  imports = [
    ./stylix.nix
    inputs.stylix.nixosModules.stylix
  ];
}
