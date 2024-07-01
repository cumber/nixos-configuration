# No welcome banner on every startup, please
$env.config.show_banner = false

$env.color_config = $light_theme

# Better history
$env.config.history.file_format = "sqlite"
# Stop multiple shells interfering with each other's up/down history
$env.config.history.isolation = true

# Carapace for completion
# Taken from commented out example in default-config.nu
$env.config.completions.external.completer = { |spans|
    carapace $spans.0 nushell ...$spans | from json
}

# Alacritty supports kitty keyboard protocol
$env.config.use_kitty_protocol = true
