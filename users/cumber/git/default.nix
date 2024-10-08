{ ... }:
let make-rules = import ./make-github-remote-rules.nix;

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

    includes = cellfield-rules ++ grantshub-rules;
  };
}
