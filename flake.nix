{
  inputs = {
    opam-nix.url = "github:tweag/opam-nix";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.follows = "opam-nix/nixpkgs";
    # maintain a different opam-repository to those pinned upstream
    opam-repository = {
      url = "github:ocaml/opam-repository";
      flake = false;
    };
    opam-nix.inputs.opam-repository.follows = "opam-repository";
  };
  outputs = { self, flake-utils, opam-nix, nixpkgs, ... }@inputs:
    let package = "hyperbib";
    in flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        on = opam-nix.lib.${system};
        scope =
          on.buildOpamProject' { } ./. {
            ocaml-base-compiler = "*";
            # dune = "*";
            # ptime = "*";
            };
        overlay = final: prev:
          {
            # Your overrides go here
          };
      in {
        legacyPackages = scope.overrideScope' overlay;

        packages.default = self.legacyPackages.${system}.${package};
      });
}
