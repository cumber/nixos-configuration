{
  allowUnfreePredicate = (pkg:
    builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) [
      "fahcontrol"
      "fahviewer"
    ]
  );
}
