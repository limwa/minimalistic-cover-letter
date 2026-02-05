{
  description = "A basic flake for Typst writing with Nix and NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:limwa/nix-flake-utils";

    # Needed for shell.nix
    flake-compat.url = "github:edolstra/flake-compat";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    ...
  }:
    utils.lib.mkFlakeWith {
      forEachSystem = system: {
        outputs = utils.lib.forSystem self system;

        pkgs = import nixpkgs {
          inherit system;
        };
      };
    } {
      formatter = {pkgs, ...}: pkgs.alejandra;

      packages = utils.lib.invokeAttrs {
        default = { outputs, ... }: outputs.packages.minimalistic-cover-letter;

        minimalistic-cover-letter = { outputs, ... }: outputs.packages.minimalistic-cover-letter_0_1_0;

        minimalistic-cover-letter_0_1_0 = { pkgs, ... }: pkgs.buildTypstPackage {
          pname = "minimalistic-cover-letter";
          version = "0.1.0";

          src = ./minimalistic-cover-letter/0.1.0;

          typstDeps = let
            recurseIntoTypstDeps = deps: pkgs.lib.unique (deps ++ pkgs.lib.concatMap (dep: recurseIntoTypstDeps dep.typstDeps) deps);
          in
            recurseIntoTypstDeps (with pkgs.typstPackages; [
              datify_1_0_0
            ]);
        };
      };

      devShells = utils.lib.invokeAttrs {
        default = {outputs, ...}: outputs.devShells.typst;

        # Typst development shell
        typst = {pkgs, outputs, ...}:
          pkgs.mkShellNoCC {
            meta.description = "A development shell with Typst";

            packages = with pkgs; [
              (typst.withPackages (ps: [
                outputs.packages.minimalistic-cover-letter
              ]))
            ];
          };
      };
    };
}
