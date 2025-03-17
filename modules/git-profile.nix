{ config, pkgs, ... }:

let
  sshKeyPathPersonal = "${config.home.homeDirectory}/.ssh/id_ed25519_git";
  sshKeyPathWork = "${config.home.homeDirectory}/.ssh/id_rsa_paradigm";
in
{
  # SSH Key Generation and File Setup as Activation Script
  home.activation.scripts = [
    # Generate SSH keys if they don't exist
    {
      name = "generate-ssh-keys";
      text = ''
        if [ ! -f ${sshKeyPathPersonal} ]; then
          echo "Generating SSH key for GitHub (personal)"
          ssh-keygen -t ed25519 -C "shonpt@outlook.com" -f ${sshKeyPathPersonal} -N ""
        fi
        if [ ! -f ${sshKeyPathWork} ]; then
          echo "Generating SSH key for Bitbucket (work)"
          ssh-keygen -t rsa -b 4096 -C "shon.thomas@myparadigm.com" -f ${sshKeyPathWork} -N ""
        fi
      '';
    }
  ];

  # File configuration for SSH keys with correct file permissions
  #home.file.".ssh/id_ed25519_git" = {
  #source = null;  # SSH key content will be generated via activation script
  #mode = "0600";  # Correct file permissions for private key
  #};

  #home.file.".ssh/id_rsa_paradigm" = {
  #source = null;  # SSH key content will be generated via activation script
  #mode = "0600";  # Correct file permissions for private key
  #};

  # SSH config
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
}
