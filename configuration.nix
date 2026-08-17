{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Internationalisation
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

  # Fonts (JetBrainsMono Nerd Font)
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Enable hardware and OpenGL / Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Virtualization settings (VMware Guest additions)
  services.xserver.videoDrivers = [ "vmware" ];
  virtualisation.vmware.guest.enable = true;
  virtualisation.vmware.guest.headless = false;

  # Fallback variables for Wayland / Hyprland in VM
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    LIBGL_ALWAYS_SOFTWARE = "1";
  };

  # 1. Enable Hyprland & Wayland Core
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Hyprlock PAM integration
  programs.hyprlock.enable = true;

  # Polkit authentication support
  security.polkit.enable = true;

  # Display Manager (GDM)
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = false;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Printing
  services.printing.enable = true;

  # Sound with Pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User account
  users.users."josephl" = {
    isNormalUser = true;
    description = "Joseph Lauria";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Web browser
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System Packages
  environment.systemPackages = with pkgs; [
    neovim
    git
    vscode
    kitty
    rofi 
    waybar
    wl-clipboard
    libnotify
    dunst
    swaybg
    psmisc
  ];

# Automatically clean up old Nix store generations weekly
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Optimize storage by hardlinking identical files
  nix.settings.auto-optimise-store = true;

  system.stateVersion = "26.05";
}
