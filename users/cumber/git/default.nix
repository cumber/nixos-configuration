{ ... }:
let make-rules = import ./make-github-remote-rules.nix;

    # Because I use hasconfig:remote rules to override sshCommand to
    # supply the private key for other GitHub accounts, my "default"
    # SSH key for github.com can't be included in my .ssh/config file
    # either. So I need hasconfig:remote rules that matche any
    # github repository to supply my default key, so that it can be
    # overriden by other more-specific rules later.
    personal-rules = make-rules {
      identity = "id_ssh";
    };

    cellfield-rules = make-rules {
      github-owner = "cellfield";
      email = "ben@cellfield.com";
      identity = "id_cellfield";
    };

    grantshub-rules = make-rules {
      github-owner = "thegrantshub";
      email = "ben@thegrantshub.com.au";
      identity = "id_grantshub";
    };
in
{
  programs.git = {
    userEmail = "ben@smokingkangaroo.com";
    userName = "Benjamin Mellor";

    includes = personal-rules ++ cellfield-rules ++ grantshub-rules;
  };
}
