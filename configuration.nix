{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hyper"; # Define your hostname.

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Americas/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo.wheelNeedsPassword = false; 
 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root.hashedPassword = "!";

  users.users.m0s = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6ANoef4hQv7AI4PzS9jmMP6goacQ8FVcHXwqauVLHF serhii@balbieko.com" ];
    packages = with pkgs; [
      tree
      vim
    ];
  };

  home-manager.users.root = { pkgs, ...}: {
    home.packages = [
      pkgs.git
    ];

    programs.git = {
      enable = true;
      userName  = "Serhii Balbieko";
      userEmail = "serhii@balbieko.com";
    };

    home.stateVersion = "24.11";
  };

  home-manager.users.m0s = { pkgs, ...}: {
    home.packages = [
      pkgs.git
    ];

    programs.git = {
      enable = true;
      userName  = "Serhii Balbieko";
      userEmail = "serhii@balbieko.com";
    };

    home.stateVersion = "24.11";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}

