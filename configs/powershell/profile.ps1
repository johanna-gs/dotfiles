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
