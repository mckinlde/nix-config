# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable Tailscale
  services.tailscale.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Hyprland
  services.xserver.displayManager.lightdm.enable = false; # login manager breaks things with hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable udisks2 for automount and permissions management
  services.udisks2.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dmei = {
    isNormalUser = true;
    description = "dmei";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
      firefox # ToDo: webscraping with geckodriver, start saving config/settings
      vscodium # ToDo: start saving vscodium config/settings
      tailscale # ToDo: setup
      vlc
      pgadmin4-desktopmode # ToDo: setup, start saving config/auths
      lf # I forget what this is for
      kitty # terminal
      wofi # I forget what this is for
      kdePackages.dolphin # File Explorer GUI
      waybar # Top bar, ToDo: start tracking config
      networkmanagerapplet # WiFi GUI? Application?  Can I get on wifi without this? (maybe just from terminal?)
      obsidian # Notes app
      google-chrome # Sigh.  Gotta have chrome for the odd extension or chromedriver.
      libreoffice-qt-fresh # time to get some office tools      
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # VirtualBox support
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "dmei" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    ## This next section is stuff that I need to support @Matoska's /.bashrc
    zellij # terminal multiplexer; tmux but better
    coreutils
    bash-completion
    fzf
    yazi
    ## end @Matoska's /.bashrc dependencies
    git # local git
    gh # online github (ssh tools)
    git-lfs # git large file storage
    htop # I forget what I needed htop for but I'm sure it was important
    wget
    unzip
    brightnessctl # needed for screen brightness adjustments
    dig
    # Reading and formatting random USBs
    usbutils
    parted
    exfatprogs
    # ToDo: start syncing files to home NAS with syncthing
    syncthing
    tree # this is for drawing filestructure in terminal
    # Clipboard tools (b/c I'm unable to copy/paste between vscodium and firefox?? What the hell?
    wl-clipboard # for Wayland
    xclip        # for X11
    kitty
    # ToDo: clipboard still breaks sometimes, mostly when cp/pst-ing from vscode to firefox
    jq # for parsing json
    # End clipboard tools; TODO: FireFox is having annoying windowing/settings issues
    postgresql
    # VirtualBox
    virtualbox
    virtualboxExtpack
  ];


  # add fonts (needed for waybar icons, except with Matoska's Nix they're working?  Are these wrapped in a hyprland or waybar config?)
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
     ];
  };

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
