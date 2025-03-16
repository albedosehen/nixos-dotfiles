{config, pkgs, ...}: 
{
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
      stdlib = ''
        # Enhanced devenv integration
        use_devenv() {
          watch_file devenv.nix
          watch_file devenv.lock
          watch_file devenv.yaml
          watch_file flake.lock
          watch_file pyproject.toml
          watch_file uv.lock

          # Add error handling and timeout
          local max_attempts=3
          local attempt=1
          local timeout=300  # 5 minutes timeout

          while [ $attempt -le $max_attempts ]; do
            if timeout $timeout devenv shell --print-bash; then
              eval "$(timeout $timeout devenv shell --print-bash)"
              return 0
            fi
            echo "Attempt $attempt failed, retrying..."
            attempt=$((attempt + 1))
            sleep 5
          done

          echo "Failed to initialize devenv after $max_attempts attempts"
          return 1
        }
      '';
    };
}