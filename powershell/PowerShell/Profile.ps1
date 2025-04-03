# how to install modules:
# ```
# Install-Module Posh-git -Scope CurrentUser -Force
# Install-Module PSReadLine -Repository PSGallery -Scope CurrentUser -Force
# ```
#
# TODO: figure out how to do that automatically?

Import-Module posh-git

Set-PSReadLineOption -PredictionSource History -EditMode Emacs
