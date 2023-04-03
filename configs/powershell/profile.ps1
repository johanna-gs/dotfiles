New-Alias g goto

function goto {
    param (
        $location
    )

    Switch ($location) {
        "ps" {
            Set-Location -Path "$HOME/privatespace"
        }
        "ws" {
            Set-Location -Path "$HOME/workspace"
        }
        "dot" {
            Set-Location -Path "$HOME/dotfiles"
        }
        default {
            echo "Invalid location"
        }
    }
}

$ENV:STARSHIP_CONFIG = "$HOME\.config\starship.toml"
$ENV:STARSHIP_DISTRO = "者 ak"
Invoke-Expression (&starship init powershell)

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
