{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, python3
, libGL
, libX11
, libXcursor
, libXi
, libXrandr
, libxcb
, libxkbcommon
, AppKit
, IOKit
}:

rustPlatform.buildRustPackage rec {
  pname = "epick";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "vv9k";
    repo = pname;
    rev = version;
    sha256 = "sha256-x1C8kY9VpMg7aXgC/jRsLCeUV8uRLobgjSAQdK2/sHk=";
  };

  cargoSha256 = "sha256-KgQOlvKRt47lg7NteqBa2DLKkDf93JTzp9EIHn3clxY=";

  nativeBuildInputs = lib.optional stdenv.isLinux python3;

  buildInputs = lib.optionals stdenv.isLinux [
    libGL
    libX11
    libXcursor
    libXi
    libXrandr
    libxcb
    libxkbcommon
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    IOKit
  ];

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf --set-rpath ${lib.makeLibraryPath buildInputs} $out/bin/epick
  '';

  meta = with lib; {
    description = "Simple color picker that lets the user create harmonic palettes with ease";
    homepage = "https://github.com/vv9k/epick";
    changelog = "https://github.com/vv9k/epick/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
