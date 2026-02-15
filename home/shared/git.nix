# Shared git configuration: multi-identity, SSH URL rewriting, aliases
{ config, lib, pkgs, ... }:

{
  programs.git = {
    # located here: ~/.config/git/config
    enable = true;
    signing = {
      key = "";
      signByDefault = false;
    };
    includes = [
      {
        contents = {
          user = {
            email = "matt@work.com";
            name = "Matt Nodurfth";
          };
        };
        condition = "gitdir:~/repos/work/";
      }
    ];
    settings = {
      user = {
        name = "Matt Nodurfth";
        email = "mnodurft@gmail.com";
      };
      alias = {
        prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        root = "rev-parse --show-toplevel";
      };
      core = {
        editor = "nvim";
        askPass = ""; # needs to be empty to use terminal for ask pass
      };
      credential.helper = "store"; # want to make this more secure
      branch.autosetuprebase = "always";
      color.ui = true;
      github.user = "nodu";
      push.default = "tracking";
      init.defaultBranch = "main";
      url = {
        "git@bitbucket.com:" = {
          insteadOf = "https://bitbucket.com/";
        };
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };
}
