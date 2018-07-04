self: super:
  let hostName = (import <nixpkgs/nixos> {}).config.networking.hostName;
      configToDeploy = super.runCommand "nixos-configuration-files" {} ''
        cp -r ${./nixos} $out
        substituteInPlace $out/configuration.nix \
          --replace '(throw "replace this throw with machine-specific module")' \
                    './${hostName}.nix'
      '';
   in {
        nixos-config = super.writeShellScriptBin "nixos-config" ''
          function mkdiff {
            ${self.colordiff}/bin/colordiff -Naur /etc/nixos ${configToDeploy} \
              -x secrets \
              -x "nix-serve.pub" \
              -x hardware-configuration.nix \
              "$@"
          }
          if [[ ''${1-diff} = "diff" ]]; then
            echo "Differences to deploy:"
            mkdiff
          elif [[ $1 = "deploy" ]]; then
            patch="$(mktemp)"
            mkdiff --color=no > "$patch"
            sudo patch -p4 -d /etc/nixos < "$patch"
          else
            >&2 echo "Bad argument: $1"
            exit 1
          fi
        '';
      }
