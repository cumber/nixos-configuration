{ ... }:
{
  # Allow mutable time zone for laptop
  time.timeZone = null;

  services = {
    geoclue2.enable = true;
    localtimed.enable = true;
  };
}
