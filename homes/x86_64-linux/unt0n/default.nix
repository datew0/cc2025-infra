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
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "unt0n";

  home.packages = with pkgs; [
    neofetch
    iftop
    htop
    lsof
    ncdu # disk usage analyzer
    tmux
    wget
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "fzf" ];
    };

    shellAliases = {
      ll = "ls -lh";
      rkn = "rm -rf ~/.ssh/known_hosts";
    };


    history.size = 10000; 
  };

  programs.fzf.enable = true;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      line_break.disabled = true;
      directory.truncation_length = 1;
      docker_context.disabled = true;
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      set -sg escape-time 100 # escape-seq workaround
    '';
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
