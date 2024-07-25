# Helper functions for generating bitfields for controlling river tags. See
# https://codeberg.org/river/wiki/src/branch/master/pages/How-tags-work.md
#
# There is some ambiguity in the term "tag" in common usage; it often either
# refers to the numeric *label* of the tag used in UI and commands (commonly
# 1-9, since those are convenient keyboard commands), but river core docs refer
# to tags as the bitfields associated with each output and window. I will use
# "labels" and "masks" to be precise here.
lib:

rec {
  all-labels = lib.range 1 9;

  mask-for-label = label: pow 2 label;
  mask-for-labels = labels: builtins.foldl' builtins.bitOr 0 (builtins.map mask-for-label labels);

  label-for-scratchpad = 0;
  mask-for-scratchpad = mask-for-label label-for-scratchpad;

  # Simple exponentiation by repeated multiplication for shifting tag bitmasks.
  # Inefficient, but only runs at build time.
  pow =
    x: y:
    assert lib.isInt y;
    assert y >= 0;
    let
      pow-impl = x: y: if y == 0 then 1 else x * (pow-impl x (y - 1));
    in
    pow-impl x y;

}
