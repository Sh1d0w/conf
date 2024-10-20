{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation rec {
  pname = "tpm";
  version = "latest";  # You can replace this with a specific version or commit hash

  src = fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tpm";
    rev = "master";  # You can pin a specific commit hash here
    sha256 = lib.fakeSha256;  # Set this to the correct hash if you know it, or use `nix-prefetch-git`
  };

  installPhase = ''
    mkdir -p $HOME/.tmux/plugins/tpm
    cp -r * $HOME/.tmux/plugins/tpm/
  '';

  meta = with stdenv.lib; {
    description = "Tmux Plugin Manager";
    homepage = "https://github.com/tmux-plugins/tpm";
    license = licenses.mit;
    maintainers = with maintainers; [ ]; # Add maintainers if needed
  };
}