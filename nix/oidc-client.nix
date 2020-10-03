{ mkDerivation, aeson, attoparsec, base, bytestring, cryptonite
, exceptions, fetchgit, hspec, http-client, http-client-tls
, http-types, jose-jwt, network, network-uri, scientific, stdenv
, text, time, tls
}:
mkDerivation {
  pname = "oidc-client";
  version = "0.5.1.0";
  src = fetchgit {
    url = "https://github.com/krdlab/haskell-oidc-client";
    sha256 = "0x42s3k5v0gflvmgf811028iy70ldiw6llasjdj4cx9mwryxwmvd";
    rev = "f4338c958877705e5071c0c7ac970799cdc5c624";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson attoparsec base bytestring cryptonite exceptions http-client
    http-client-tls jose-jwt network network-uri scientific text time
    tls
  ];
  testHaskellDepends = [
    aeson base bytestring cryptonite exceptions hspec http-client
    http-client-tls http-types jose-jwt network-uri scientific text
    time
  ];
  homepage = "https://github.com/krdlab/haskell-oidc-client";
  description = "OpenID Connect 1.0 library for RP";
  license = stdenv.lib.licenses.mit;
}
