{
  programs.distrobox = {
    enable = true;
    enableSystemdUnit = true;
    settings = {
      container_manager = "podman";
      container_always_pull = "1";
      container_generate_entry = 1;
    };
    containers = {
      thesis = {
        image = "ubuntu:latest";
        entry = true;
        additional_packages = [
          "zsh"
          "git"
          "curl"
          "build-essential"
          "python3"
          "python3-pip"
          "software-properties-common"
          "golang"
          "nvim"
          "vim"
        ];
        environment = [
          "SHELL=zsh"
        ];
        # init_hooks = [
        #   "sudo apt update"
        #   "sudo apt install -y ca-certificates curl gnupg"
        #
        #   "sudo install -m 0755 -d /etc/apt/keyrings"
        #
        #   "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg"
        #
        #   "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
        #
        #   "sudo apt update"
        #   "sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
        #
        #   "sudo service docker start"
        #   "sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch"
        #   "sudo apt update"
        #   "sudo apt install -y fastfetch"
        # ];
      };
    };
  };
}
