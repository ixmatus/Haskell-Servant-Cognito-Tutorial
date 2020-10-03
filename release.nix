let
  config   = { allowUnfree = true; };
  overlays = [
    (newPkgs: oldPkgs: rec {

      haskellPackages = oldPkgs.haskellPackages.override {
        overrides = haskellPackagesNew: _: {
          servant-cognito-tutorial = haskellPackagesNew.callCabal2nix "servant-cognito-tutorial" ./. { };
        };
      };

    })
  ];

  nixpkgs = import ./nix/20_03.nix;
  pkgs    = import nixpkgs { inherit config overlays; };

  servant-cognito-tutorial-shell = pkgs.haskellPackages.shellFor {
    withHoogle = false;
    packages = p: [
      p.servant-cognito-tutorial
    ];

    buildInputs = [
      pkgs.ghcid
      pkgs.cabal-install
    ];
  };

in

  { inherit (pkgs.haskellPackages) servant-cognito-tutorial;
    inherit servant-cognito-tutorial-shell;
  }
