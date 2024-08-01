{
  config,
  pkgs,
  ...
}: {
  # Fish
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      # Alias for lsd
      alias ls 'lsd'
      alias ll 'lsd -l'
      alias la 'lsd -a'
      alias lla 'lsd -la'

      # Git Aliases
      alias g 'git'
      alias ga 'git add'
      alias gc 'git commit'
      alias gcm 'git commit -m'
      alias gp 'git push'
      alias gpl 'git pull'
      alias gst 'git status'
      alias gb 'git branch'
      alias gco 'git checkout'
      alias gcb 'git checkout -b'
      alias gm 'git merge'
      alias gr 'git remote'
      alias gl 'git log'
      alias gd 'git diff'
      alias gcl 'git clone'

      # kubectl Aliases
      alias k='kubectl'
      alias kga='kubectl get all'
      alias kgp='kubectl get pods'
      alias kgs='kubectl get services'
      alias kgd='kubectl get deployments'
      alias kgns='kubectl get namespaces'
      alias kctx='kubectl config use-context'
      alias kns='kubectl config set-context --current --namespace'
      alias kd='kubectl describe'
      alias kdp='kubectl describe pod'
      alias kds='kubectl describe service'
      alias kdd='kubectl describe deployment'
      alias kdel='kubectl delete'
      alias kdelf='kubectl delete -f'
      alias kaf='kubectl apply -f'
      alias kcf='kubectl create -f'
      alias kex='kubectl exec -it'
      alias kl='kubectl logs'
      alias klf='kubectl logs -f'
      alias kpf='kubectl port-forward'
      alias ksc='kubectl scale'
      alias kr='kubectl rollout'
      alias krh='kubectl rollout history'
      alias krr='kubectl rollout restart'
      alias krs='kubectl rollout status'
    '';
    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
      { name = "pure"; src = pkgs.fishPlugins.pure.src; }
      { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
    ];
  };
}