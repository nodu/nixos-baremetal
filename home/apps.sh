function shell-go() {
	nix-shell -p go gopls
}

function shell-python() {
	nix-shell -p python3 entr
}

function weylus() {
	nix-shell -p weylus --run weylus
}

function gimp() {
	nix-shell -p gimp --run gimp
}

function shell-js-ts() {
	cat >tsshell.nix <<EOF
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [ pkgs.nodejs_20 pkgs.nodePackages.ts-node pkgs.yarn pkgs.entr ];

  shellHook = ''
    echo "TypeScript shell..."
    echo "ls *.ts 2>/dev/null | entr -r ts-node file.ts"
  '';
}
EOF

	nix-shell tsshell.nix
	rm -f tsshell.nix
}
