I would like to store all my cloned git repos in `~/git/` using a hierarchical structure based on
git server domain, github org and repo name. For example, the git repo at `git@ghe.spotify.net:pod-mission-integrations/netflix-delivery.git`
should be cloned to `~/git/ghe.spotify.net/pod-mission-integrations/netflix-delivery/`.
This should work for both SSH-style repo URLs (as above) and HTTPS-style (e.g. `https://ghe.spotify.net/pod-mission-integrations/netflix-delivery.git`).

To help me manage these, please produce a series of bash functions I can add to my profile. Functions should include:

1. a `gclone` command which accepts a repo URL and;
   a. clones it into the correct place
   b. changes the current directory to the new working copy
2. a `gt` command, similar to the below, which fuzzy-matches for a repo name and changes the current dir to that repo:
  ```
  gt () {
     gitpath="~/git/"
     repopath=$(find ${gitpath} -mindepth 3 -maxdepth 3 -type d | awk -F $gitpath '{print $2}' | fzf)
     cd ${gitpath}${repopath}
  }
  ```

All functions should be able to be run from any working directory on my machine.