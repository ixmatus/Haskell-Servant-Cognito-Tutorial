let
  # Supply a default, empty configuration for nixpkgs (if you have an
  # unfree, in-house package you would give `{ allowUnfree = true; }`.)
  config   = { allowBroken = true; };

  # Supply an overlay that overrides the stock set of Haskell packages
  # from the nixpkgs-20.03 pin.
  overlays = [
    (newPkgs: oldPkgs: rec {

      # Override the stock Haskell package set, providing the main
      # application that we are developing and any additional packages
      # that we want different versions of.
      haskellPackages = oldPkgs.haskellPackages.override {
        overrides = haskellPackagesNew: _: {

          # Use `callCabal2nix` to dynamically generate a Nix
          # derivation from the cabal file in the present working
          # directory.
          servant-cognito-tutorial = haskellPackagesNew.callCabal2nix "servant-cognito-tutorial" ./. { };

          # Override the stock `oidc-client` from Hackage in the
          # Haskell package set with a version at a different commit
          # from the upstream repository.
          #
          # The reason for this is to pickup some recent improvements
          # to the library.
          oidc-client = haskellPackagesNew.callPackage ./nix/oidc-client.nix { };

          # Override the stock `fourmolu` from Hackage because we want
          # the latest one (as of the time of this writing, at least.)
          fourmolu = haskellPackagesNew.callPackage ./nix/fourmolu.nix { };

          # Override the stock `optparse-generic` from Hackage because
          # we want the latest features that let us define default
          # values for options generated from record fields.
          optparse-generic = haskellPackagesNew.callPackage ./nix/optparse-generic.nix { };

          # Override the stock `optparse-applicative` from Hackage
          # because `optparse-generic` needs the newer package.
          optparse-applicative = haskellPackagesNew.callPackage ./nix/optparse-applicative.nix { };

          # Override the stock `wai-app-static` from Hackage because
          # `wai-app-static
          wai-app-static = haskellPackagesNew.callPackage ./nix/wai-app-static.nix { };
        };
      };

    })
  ];

  # Import a pin of nixpkgs-20.03, this ensures that we use an
  # explicit version of nixpkgs and do not rely on an ambient nixpkgs
  # provided by a user's channel that may be unknown (or not even set
  # if they haven't configured a channel!)
  nixpkgs = import ./nix/20_03.nix;

  # Instantiate a package-set from the imported `nixpkgs` pin, supply
  # our overlays and our configuration.
  pkgs    = import nixpkgs { inherit config overlays; };

  # Produce a custom derivation for use with `nix-shell`. We add the
  # application we're working on to the `packages` list (the
  # `haskellPackages` parameter is fed the `haskellPackages` attribute
  # set from the package set, the set we overrode in the overlay
  # above.)
  #
  # This will generate an isolated environment from which we can
  # develop our application without ever installing anything (except
  # for Nix) globally.
  #
  # We add `ghcid`, `cabal-install`, and `fourmolu` to the
  # `buildInputs` so that we don't need to install those globally
  # either and can use them from the command line within the temporary
  # Nix shell.
  servant-cognito-tutorial-shell = pkgs.haskellPackages.shellFor {
    withHoogle = false;
    packages = haskellPackages: [
      haskellPackages.servant-cognito-tutorial
    ];

    buildInputs = [
      pkgs.ghcid
      pkgs.cabal-install
    ];
  };

in

  # Expose our application derivation and its custom shell derivation
  # for use with `nix-shell` or `nix-build`; e.g:
  #
  #     `nix build servant-cognito-tutorial -f ./release.nix
  #
  # ... will build our application.
  { inherit (pkgs.haskellPackages) fourmolu servant-cognito-tutorial;
    inherit servant-cognito-tutorial-shell;
  }
