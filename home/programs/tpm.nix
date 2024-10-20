{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation rec {
  pname = "tpm";
  version = "latest";  # You can replace this with a specific version or commit hash

  src = fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tpm";
    rev = "master";  # You can pin a specific commit hash here
    sha256 = "01ribl326n6n0qcq68a8pllbrz6mgw55kxhf9mjdc5vw01zjcvw5";
  };

  installPhase = ''
    mkdir -p $out/share/tmux/plugins/tpm
    cp -r * $out/share/tmux/plugins/tpm/
  '';

  meta = {
    description = "Tmux Plugin Manager";
    homepage = "https://github.com/tmux-plugins/tpm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ]; # Add maintainers if needed
  };
}