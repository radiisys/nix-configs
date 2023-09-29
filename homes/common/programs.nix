_: {
  # enable programs
  programs = {
    git = {
	enable = true;
	userName = "radiisys";
	userEmail = "radisys@proton.me";
	extraConfig = {
		commit.gpgsign = true;
		gpg.format = "ssh";
		user.signingkey = "~/.ssh/id_ed25519.pub";
		init.defaultBranch = "master";
        };
    };
    neovim.enable = true;
    waybar = {
      enable = true;
      settings = import ./waybar.nix;
      style = import ./waybar-style.nix;
    };
    # ... add more programs as you see fit
  };
}
