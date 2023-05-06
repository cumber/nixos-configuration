{ ... }: {
  programs.git = {
    userEmail = "ben@smokingkangaroo.com";
    userName = "Benjamin Mellor";

    # Specify the default SSH key here so that includeif rules for
    # different remotes can override it; if this key is available by
    # default in .ssh/config, then SSH will always be aware of it *in
    # addition* to any other keys specified for particular remotes.
    extraConfig.core.sshCommand = "ssh -i ~/.ssh/id_ssh";
  };
}
