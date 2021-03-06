# Configure your own Haskell nix shell!
let
  # Do not touch this part.
  tooling = import ./nix;
  pkgs = tooling.pkgs;
  deps =
    [ pkgs.zlib
    ];

  # Change GHC version here. If unsure about what's available, open a
  # shell and run `nix repl`:
  #
  # $ nix repl
  # nix-repl> tooling = import ./nix
  # nix-repl> tooling.haskell
  # { ghc8102 = { ... }; ghc865 = { ... }; ghc844 = { ... }; }
  #
  # You can pick any of the above.
  self = tooling.haskell.ghc8102;

  # inputs is used below
  inputs = self.packages;

  # Common tooling used by the whole team/CI. Remove if you'd rather
  # use the system-wide version you might already have.
  commonTooling =
    [ self.compiler # GHC version as defined above at 'self'
      inputs.stylish-haskell
      inputs.hlint
      inputs.cabal-install
    ];

  # Personal tooling: change/update as needed, e.g. `inputs.ghcide`.
  personalTooling =
    [ inputs.haskell-language-server
      inputs.cabal2nix
      inputs.implicit-hie
    ];
in
  pkgs.mkShell {
    buildInputs = deps ++ commonTooling ++ personalTooling;
  }
