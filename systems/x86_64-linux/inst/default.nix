{
    # Snowfall Lib provides a customized `lib` instance with access to your flake's library
    # as well as the libraries available from your flake's inputs.
    lib,
    # An instance of `pkgs` with your overlays and packages applied is also available.
    pkgs,
    # You also have access to your flake's inputs.
    inputs,

    # Additional metadata is provided by Snowfall Lib.
    system, # The system architecture for this host (eg. `x86_64-linux`).
    target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
    format, # A normalized name for the system target (eg. `iso`).
    virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
    systems, # An attribute map of your defined hosts.

    # All other arguments come from the system system.
    config,
    ...
}:
{
  imports = [
    ./networking.nix
    ./hardware.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    # inputs.vscode-server.nixosModules.default
  ];


  networking.hostName = "inst";

  time.timeZone = "Europe/Moscow";

  zramSwap.enable = true;

#   virtualisation.containers.enable = true;
#   virtualisation = {
#     podman = {
#       enable = true;

#       # Required for containers under podman-compose to be able to talk to each other.
#       defaultNetwork.settings.dns_enabled = true;
#     };
#   };

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "jenkins" ];

  environment.systemPackages = with pkgs; [
    git
    docker-compose
    docker-buildx
    jdk21_headless
    openstackclient-full
    terraform
    ansible
  ];

  services.qemuGuest.enable = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "prohibit-password";
  };

  programs.zsh.enable = true;
  
  users.mutableUsers = false;
  users.users.root.openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOmAKoDj0YaRo4Xd+hHXs8K5yzZ8ytn7amgG8eIRCn5yAAAAB3NzaDpsYWI="
  ];

  users.users.unt0n = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ]; # Enable sudo for the user.
    hashedPassword = "$y$j9T$HmDh49x4HjWmFq08DAADJ0$QiZGdXSecoqdKap0PNa/gpASkqsCPnPrN/rodp4CL/5"; # 123OTT
    openssh.authorizedKeys.keys = [ "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOmAKoDj0YaRo4Xd+hHXs8K5yzZ8ytn7amgG8eIRCn5yAAAAB3NzaDpsYWI=" ];
  };

  users.users.jenkins = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [ "docker" ];
    hashedPassword = "$y$j9T$HmDh49x4HjWmFq08DAADJ0$QiZGdXSecoqdKap0PNa/gpASkqsCPnPrN/rodp4CL/5"; # 123OTT
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEcwC52M6WYAt4krnquADI7DRfiqWpx03oIJxCQapVwa" ];
  };

  users.groups."jenkins".members = [ "jenkins" ];

  systemd.services.jenkins-agent = {
    description = "Jenkins Agent";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      User = "jenkins";
      Group = "jenkins";
      WorkingDirectory = "/var/jenkins";
      Path = [
        pkgs.coreutils
        pkgs.git
        pkgs.docker
      ];
      ExecStart = ''
        ${pkgs.jdk21_headless}/bin/java \
          -jar /home/jenkins/agent.jar \
          -url http://192.168.199.88:8080/ \
          -secret @/home/jenkins/jenkins.key \
          -name 'GavrilovA-Node' \
          -webSocket \
          -workDir /var/jenkins
      '';
      Restart = "always";
    };
  };


  nix.settings.trusted-users = [ "unt0n" ];

  disko.devices.disk.main.imageSize = "4G";
  system.stateVersion = "25.05";
}