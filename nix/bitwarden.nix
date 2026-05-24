{ config, lib, pkgs, ... }:

let
  cfg = config.siga.bitwarden;
  sshAuthSock = "$HOME/.bitwarden-ssh-agent.sock";
in
{
  options.siga.bitwarden = {
    enable = lib.mkEnableOption "bitwarden-desktop";

    sshAgent = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Use Bitwarden Desktop as the SSH agent by pointing
        $SSH_AUTH_SOCK at its Unix socket. The SSH agent feature
        must also be enabled inside the Bitwarden Desktop app.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.bitwarden-desktop ];

    environment.sessionVariables = lib.mkIf cfg.sshAgent {
      SSH_AUTH_SOCK = sshAuthSock;
    };
  };
}
