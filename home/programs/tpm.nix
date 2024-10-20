{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation rec {
  pname = "tpm";
  version = "3";

  src = fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tpm";
    rev = "99469c4a9b1ccf77fade25842dc7bafbc8ce9946";  # You can pin a specific commit hash here
    sha256 = "01ribl326n6n0qcq68a8pllbrz6mgw55kxhf9mjdc5vw01zjcvw5";
  };

  installPhase = ''
    echo "Creating installation directory at $out/share/tmux/plugins/tpm"
    mkdir -p $out/share/tmux/plugins/tpm
    echo "Copying files to installation directory..."
    cp -r * $out/share/tmux/plugins/tpm/
    echo "Installed files:"
    ls -la $out/share/tmux/plugins/tpm
  '';

  meta = {
    description = "Tmux Plugin Manager";
    homepage = "https://github.com/tmux-plugins/tpm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ]; # Add maintainers if needed
  };
}