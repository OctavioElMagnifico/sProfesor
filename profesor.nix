{ mkDerivation, base, directory, stdenv, wreq }:
mkDerivation {
  pname = "sProfesor";
  version = "0.2.0.1";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base directory wreq ];
  executableHaskellDepends = [ base directory ];
  testHaskellDepends = [ base ];
  homepage = "https://github.com/OctavioElMagnifico/sProfesor#readme";
  license = stdenv.lib.licenses.gpl3;
}
