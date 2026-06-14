# DevBox

On any new machine:

1. Install git, Docker, and DevPod.
2. Configure DevPod:

   ```bash
   devpod provider add docker
   devpod provider use docker
   devpod ide use none
   devpod context set-options -o SSH_AGENT_FORWARDING=true
   ```

3. Create the workspace folder:

   ```bash
   mkdir -p ~/workspace/saipr0
   ```

4. Clone this repo:

   ```bash
   git clone git@github.com:saipr0/dev-dotfiles.git ~/workspace/saipr0/dev-dotfiles
   ```

5. Start and enter the devbox:

   ```bash
   cd ~/workspace/saipr0/dev-dotfiles
   devpod up .
   devpod ssh devbox
   ```
