cursor() {
  # bash function to open cursor in a dev container
  # this prevents cursor from gaining read access to the whole filesystem on macOS

  # If the last argument is not a directory (or "."), pass through to cursor unchanged.
  if [[ $# -eq 0 || ! ( "${!#}" == "." || -d "${!#}" ) ]]; then
    command cursor "$@"
    return
  fi

  # set the container root as the final argument
  # and remove it from the arguments list
  local container_root="${!#}"
  set -- "${@:1:$#-1}"
  local -a passthrough=("$@")

  # init variables
  local abs="$(cd "$container_root" && pwd)"
  local base="$(basename "$abs")"
  local dc_folder_path="$abs/.devcontainer"
  local dc_spec_path="$dc_folder_path/devcontainer.json"

  # check if the dev container spec exists
  if [[ ! -d "$dc_folder_path" || ! -f "$dc_spec_path" ]] ;
  then
    echo "No dev container spec found at $dc_spec_path."
    echo "Please create one."
    echo "Aborting..."
    return
  else
    echo "Opening cursor in container for workspace: $abs..."
  fi

  # encode the workspace path as a hex string
  local hex=$(python3 -c "import sys; print(sys.argv[1].encode().hex())" "$abs")

  # call the cursor binary with remote
  command cursor --remote "dev-container+${hex}" "/workspaces/${base}" "${passthrough[@]}"
}

kdevc() {
    # kill & remove all dev containers
    docker ps | grep devcontainer | cut -d' ' -f1 | xargs docker kill
    docker ps -a | grep devcontainer | cut -d' ' -f1 | xargs docker remove
}
