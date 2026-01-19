{
    # Snowfall Lib provides a customized `lib` instance with access to your flake's library
    # as well as the libraries available from your flake's inputs.
    lib,
    # An instance of `pkgs` with your overlays and packages applied is also available.
    pkgs,
    # You also have access to your flake's inputs.
    inputs,

    # Additional metadata is provided by Snowfall Lib.
    home, # The home architecture for this host (eg. `x86_64-linux`).
    target, # The Snowfall Lib target for this home (eg. `x86_64-home`).
    format, # A normalized name for the home target (eg. `home`).
    virtual, # A boolean to determine whether this home is a virtual target using nixos-generators.
    host, # The host name for this home.

    # All other arguments come from the home home.
    config,
    ...
}:
{
    home.username = "jenkins";
    # home.packages = with pkgs; [
    #     git
    # ];

    # Autostart w/o user login: sudo loginctl enable-linger $(whoami)
    # systemd.user.services.jenkins-agent = {
    #     Unit = {
    #         Description = "Jenkins Agent Service";
    #         # Requires = [ "docker.service" ];
    #         # After = [ "podman.service" ];
    #     };
    #     Install = {
    #         WantedBy = [ "default.target" ];
    #     };
    #     Service = {
    #         Type = "exec";
    #         # WorkingDirectory = "/home/unt0n/remnanode";  # Путь к вашей папке с compose-файлом
    #         ExecStart = "${pkgs.jdk21_headless}/bin/java -jar agent.jar -url http://192.168.199.88:8080/ -secret jenkins.key -name 'GavrilovA-Node' -webSocket -workDir /var/jenkins";
    #         # ExecStop = "${pkgs.jdk21_headless}/bin/podman compose down";  # Остановка при завершении службы
    #         # Environment = "PATH=${pkgs.jdk21_headless}/bin:/run/wrappers/bin"; # wrappers нужен, чтобы у newuidmap был SUID бит
    #         Restart = "on-failure";                     # Перезапуск при падении
    #         # TimeoutStopSec = 30;
    #     };
    # };


    home.file."agent.jar" = {
        source = ./agent.jar;
        executable = true;
    };

    # home.file."jenkins.key" = {
    #     source = ./jenkins.key;
    # };

    home.stateVersion = "25.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
