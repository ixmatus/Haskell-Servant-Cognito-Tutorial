{ mkDerivation, base, bytestring, Only, optparse-applicative
, stdenv, system-filepath, text, time, transformers, void
}:
mkDerivation {
  pname = "optparse-generic";
  version = "1.4.4";
  sha256 = "e44853c0a3def2556cec31337db411d6404d7f81d505662f8ebac68e119bc077";
  libraryHaskellDepends = [
    base bytestring Only optparse-applicative system-filepath text time
    transformers void
  ];
  description = "Auto-generate a command-line parser for your datatype";
  license = stdenv.lib.licenses.bsd3;
}
