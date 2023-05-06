{ ... }:
# Need multiple rules to cover scp-style host specifiers and proper
# URLS using an explicit ssh:// or git+ssh:// protocol
let configFor = stem: {
      condition = "hasconfig:remote.*.url:${stem}";
      contents = {
        user.email = "ben@thegrantshub.com.au";
        core.sshCommand = "ssh -i ~/.ssh/id_grantshub";
      };
    };
in
{
  programs.git.includes = map configFor [
    "git@github.com:thegrantshub/**"
    "ssh://git@github.com/thegrantshub/**"
    "git+ssh://git@github.com/thegrantshub/**"
  ];
}
