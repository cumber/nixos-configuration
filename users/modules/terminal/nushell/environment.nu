# Git commit messages open in nano otherwise.
# Can't just use ee wrapper, as --no-wait causes emacsclient to return
# before message is saved, so git doesn't see it.
$env.VISUAL = 'emacsclient --alternate-editor "" --create-frame'
