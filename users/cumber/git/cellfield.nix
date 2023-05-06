{ ... }:
# Need multiple rules to cover scp-style host specifiers and proper
# URLS using an explicit ssh:// or git+ssh:// protocol
let configFor = stem: {
      condition = "hasconfig:remote.*.url:${stem}";
      contents = {
        user.email = "ben@cellfield.com";
        core.sshCommand = "ssh -i ~/.ssh/id_cellfield";
      };
    };
in
{
  programs.git.includes = map configFor [
    "git@github.com:cellfield/**"
    "ssh://git@github.com/cellfield/**"
    "git+ssh://git@github.com/cellfield/**"
  ];
}
