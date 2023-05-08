# Function to make hasconfig:remote conditional git configurations for
# GitHub repositories owned by a specific owner.
{ github-owner ? "*", email ? null, identity }:
let configFor = pattern: {
      condition = "hasconfig:remote.*.url:${pattern}";
      contents = {
        core.sshCommand = "ssh -o IdentitiesOnly=yes -i ~/.ssh/${identity}";
      } // (if email == null then {} else {
        user.email = email;
      });
    };

    hosts = [
      "ssh://git@github.com/"
      "git+ssh://git@github.com/"
      "git@github.com:"
    ];

    patterns = builtins.concatMap
      (host: [ "${host}${github-owner}/**" ])
      hosts
    ;
in
map configFor patterns
