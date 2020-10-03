{ mkDerivation, aeson, base, bytestring, containers, directory
, dlist, exceptions, fetchgit, filepath, ghc-lib-parser, gitrev
, hspec, hspec-discover, HsYAML, HsYAML-aeson, mtl
, optparse-applicative, path, path-io, stdenv, syb, text
}:
mkDerivation {
  pname = "fourmolu";
  version = "0.2.0.0";
  src = fetchgit {
    url = "https://github.com/parsonsmatt/fourmolu";
    sha256 = "0z7njcz2m68qh27dlcn8dsgfq5p29pyrdq7y1zdnn5m4s8cday0f";
    rev = "53a57a3bd7bec4beabff4612276365f07edcdd97";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson base bytestring containers directory dlist exceptions
    filepath ghc-lib-parser HsYAML HsYAML-aeson mtl syb text
  ];
  executableHaskellDepends = [
    base directory ghc-lib-parser gitrev optparse-applicative text
  ];
  testHaskellDepends = [
    base containers filepath hspec path path-io text
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/parsonsmatt/fourmolu";
  description = "A formatter for Haskell source code";
  license = stdenv.lib.licenses.bsd3;
}
