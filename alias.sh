#!/usr/bin/env bash

# Usage:
#   source ./alias.sh
#   pbp Project.csproj studio
#
# pbp = Project Build + Push (clio)
pbp() {
	local csproj="$1"
	local env="$2"

	if [[ -z "$csproj" || -z "$env" ]]; then
		echo "Usage: pbp <path/to/project.csproj> <clio_env>" >&2
		echo "Example: pbp LcDevOpsMonitor.csproj studio" >&2
		return 2
	fi

	dotnet build "$csproj" -c Release
	local build_exit=$?
	if [[ $build_exit -ne 0 ]]; then
		echo "dotnet build failed (exit code: $build_exit). Skip: clio pushw" >&2
		return $build_exit
	fi

	clio pushw -e "$env"
}

