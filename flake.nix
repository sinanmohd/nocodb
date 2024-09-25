{
  description = "Open Source Airtable Alternative";

  inputs.nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      lib = nixpkgs.lib;

      forSystem =
        f: system:
        f {
          inherit system;
          pkgs = import nixpkgs { inherit system; };
        };

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: lib.genAttrs supportedSystems (forSystem f);
    in
    {
      devShells = forAllSystems (
        { system, pkgs }:
        {
          default = pkgs.mkShell {
            name = "dev";

            packages = with pkgs; [
              shfmt
              nixfmt-rfc-style
              bash-language-server
              nodePackages.vls
              nodePackages.typescript-language-server
            ];

            shellHook = ''
              export PS1="\033[0;34m[󱘲 ]\033[0m $PS1"
            '';
          };
        }
      );
    };
}
