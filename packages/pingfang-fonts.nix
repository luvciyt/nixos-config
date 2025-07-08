# packages/pingfang-fonts.nix
{ stdenv, lib }:

stdenv.mkDerivation rec {
  pname = "pingfang-fonts";
  version = "1.0";
  
  src = ../fonts-flake/pingfang;
  
  dontBuild = true;
  
  installPhase = ''
    echo "Installing PingFang fonts..."
    mkdir -p $out/share/fonts/truetype/pingfang
    
    if [ -d "$src" ] && [ "$(ls -A $src/*.ttf 2>/dev/null)" ]; then
      cp $src/*.ttf $out/share/fonts/truetype/pingfang/
      echo "Copied $(ls $src/*.ttf | wc -l) font files"
    else
      echo "Error: No .ttf files found in $src"
      exit 1
    fi
  '';
  
  meta = with lib; {
    description = "PingFang SC fonts for NixOS";
    homepage = "https://developer.apple.com/fonts/";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}