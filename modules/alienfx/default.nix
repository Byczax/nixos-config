{ stdenv, fetchFromGitHub, python3, python3Packages, pkgconfig, cairo, gobject-introspection, libusb1, gtk3 }:

stdenv.mkDerivation rec {
  pname = "alienfx";
  version = "2.4.3";  # latest release as of Oct 30, 2023

  src = fetchFromGitHub {
    owner = "trackmastersteve";
    repo = "alienfx";
    rev = "v${version}";
    sha256 = "<INSERT_SHA256>";
  };

  nativeBuildInputs = [ pkgconfig gobject-introspection python3 ];
  buildInputs = [ cairo gtk3 libusb1 ];

  # Install phase using setup.py (install Python package + data)
  installPhase = ''
    python3 -m pip install --no-deps --prefix=$out .
    # ensures installation of CLI, GUI, and udev rules
  '';

  meta = {
    description = "CLI and GTK GUI to control Alienware lighting (AlienFX)";
    homepage = "https://github.com/trackmastersteve/alienfx";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ yourNameOrHandle ];
  };
}

