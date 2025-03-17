{ config, ... }:
let
  sshKeyPathPersonal = "${config.home.homeDirectory}/.ssh/id_ed25519_git";
  sshKeyPathWork = "${config.home.homeDirectory}/.ssh/id_rsa_paradigm";
in
{
  home.activation.scripts.sshKeySetup = ''
    if [ ! -f ${sshKeyPathPersonal} ]; then
      echo "Generating SSH key for GitHub (personal)"
      ssh-keygen -t ed25519 -C "shonpt@outlook.com" -f ${sshKeyPathPersonal} -N ""
    fi
    if [ ! -f ${sshKeyPathWork} ]; then
      echo "Generating SSH key for Bitbucket (work)"
      ssh-keygen -t rsa -b 4096 -C "shon.thomas@myparadign.com" -f ${sshKeyPathWork} -N ""
    fi
  '';

  home.file.".ssh/config".text = ''
    Host github.com
      HostName github.com
      User git
      IdentityFile ${sshKeyPathPersonal}

    Host bitbucket.org-work
      HostName bitbucket.org
      User git
      IdentityFile ${sshKeyPathWork}
  '';

  # Ensure correct permissions for the SSH keys
  home.file.".ssh/id_ed25519_git".mode = "0600";
  home.file.".ssh/id_rsa_paradigm".mode = "0600";
}
