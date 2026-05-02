{ ... }: {
  programs.git = {
    enable = true;
    userName = "kingscott";
    userEmail = "me@kingscott.ca";

    signing = {
      key = "/home/kingscott/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    aliases = {
      st = "status";
      ci = "commit";
      br = "branch";
      ch = "checkout";
      co = "checkout";
      dc = "diff --cached";
      lg = "log -p";
      l = "log --graph --decorate --pretty=oneline --abbrev-commit";
      ll = "log --pretty=format:'%h : %s' --graph --decorate";
      la = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      ls = "ls-files";
      rb = "rebase";
      com = "checkout main";
      rem = "rebase main";
      now = "diff HEAD";
      stache = "stash";
      ss = "stash";
      chp = "cherry-pick";
      pom = "push origin master";
      ssu = "submodule update --init --recursive";
      cherryfix = "revert";
      su = "push --set-upstream origin";
      # df was defined twice; keeping the last value
      df = "push -f heroku master";
      d = "push heroku master";
      cl = "!f() { git clone git@wdca.unfuddle.com:wdca/$1.git $2; }; f";
      sa = "!f() { git submodule add git@wdca.unfuddle.com:wdca/$1.git $2; }; f";
      ra = "!f() { git remote add $1 git@wdca.unfuddle.com:wdca/$2.git $3; }; f";
      ds = "!f() { ~/dev/third/git-submodule-rm/git-submodule-rm.sh $1; }; f";
      dr = "!f() { git branch -D $1; git push origin :$1; }; f";
      grab = "!f() { git branch -f $1 HEAD; git checkout $1; }; f";
      jump = "!f() { git checkout origin/$1 --quiet; git branch -f $1 HEAD; git checkout $1; }; f";
      leap = "!f() { git fetch; git checkout origin/$1 --quiet; git branch -f $1 HEAD; git checkout $1; }; f";
      co2 = "!f() { git checkout $1; git submodule update --init --recursive; }; f";
      move = "!f() { git stash; git checkout origin/$1 --quiet; git branch -f $1 HEAD; git checkout $1; git stash pop; }; f";
    };

    extraConfig = {
      core = {
        editor = "nvim";
        excludesFile = "/home/kingscott/.gitignore_global";
      };
      gpg.format = "ssh";
      init.defaultBranch = "main";
      pull.rebase = true;
      safe.directory = [ "/var/www" "/etc/nixos" ];
    };
  };
}
