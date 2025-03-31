{ config, ... }:

let
  sshKeyPathPersonal = "${config.home.homeDirectory}/.ssh/id_ed25519_git"; #FIXME: [git::sshKey] Update to your generated sshKey.
  sshKeyPathWork = "${config.home.homeDirectory}/.ssh/id_rsa_paradigm"; #FIXME: [git::work.sshKey] Update to your generated sshKey.
in
{
  # SSH Key Generation and File Setup as Activation Script
  #home.activation.scripts.sshKeySetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #  if [ ! -f ${sshKeyPathPersonal} ]; then
  #    echo "Generating SSH key for GitHub (personal)"
  #    ssh-keygen -t ed25519 -C "shonpt@outlook.com" -f ${sshKeyPathPersonal} -N ""
  #  fi
  #  if [ ! -f ${sshKeyPathWork} ]; then
  #    echo "Generating SSH key for Bitbucket (work)"
  #    ssh-keygen -t rsa -b 4096 -C "shon.thomas@myparadigm.com" -f ${sshKeyPathWork} -N ""
  #  fi
  #'';

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
  #FIXME: [git::ssh.provider] Update to your version control provider (github/bitbucket/etc..)
  home.file.".ssh/config".text = ''
    Host github.com
      HostName github.com
      User git
      IdentityFile ${sshKeyPathPersonal}

    Host bitbucket.org
      HostName bitbucket.org
      User git
      IdentityFile ${sshKeyPathWork}
  '';
}
