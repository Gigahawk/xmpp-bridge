{
  description = "Devshell and package definition";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      version = builtins.concatStringsSep "." [ "0.6.0" self.lastModifiedDate ];
    in {
      packages = {
        default = with import nixpkgs { inherit system; };
        stdenv.mkDerivation rec {
          pname = "xmpp-bridge";
          inherit version;

          src = ./.;

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          buildInputs = with pkgs; [
            libstrophe
          ];

          installPhase = ''
            make install DESTDIR=$out
          '';

          meta = with lib; {
            homepage = "https://github.com/Gigahawk/xmpp-bridge";
            description = "Connect command-line programs to XMPP ";
            license = licenses.gpl3;
            platforms = platforms.all;
          };
        };
      };
      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          pkg-config
        ];
        buildInputs = with pkgs; [
          libstrophe
        ];
      };
    });
}
