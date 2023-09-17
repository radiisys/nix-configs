_: {
  # enable programs
  programs = {
    git = {
	enable = true;
	userName = "beanigen";
	userEmail = "bigyeetusthefirst@protonmail.com";
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
      settings = import ../../common/waybar.nix;
      style = import ../../common/waybar-style.nix;
    };
    # ... add more programs as you see fit
  };
}
