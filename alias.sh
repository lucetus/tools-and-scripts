#!/usr/bin/env bash

# Usage:
#   source ./alias.sh
#   pbp Project studio
#   pbp ./packages/Project/Files/Project.csproj studio
#
# pbp = Project Build + Push (clio)
pbp() {
	local arg1="$1"
	local env="$2"
	local csproj=""

	if [[ -z "$arg1" || -z "$env" ]]; then
		echo "Usage: pbp <packageName|path/to/project.csproj> <clio_env>" >&2
		echo "Example: pbp LcDevOpsMonitor studio" >&2
		echo "Example: pbp ./packages/LcDevOpsMonitor/Files/LcDevOpsMonitor.csproj studio" >&2
		return 2
	fi

	# If user passed an explicit csproj path, use it.
	# Otherwise treat arg1 as package name and use the standard layout:
	#   ./packages/<PackageName>/Files/<PackageName>.csproj
	if [[ "$arg1" == *.csproj ]]; then
		csproj="$arg1"
	else
		csproj="./packages/$arg1/Files/$arg1.csproj"
	fi

	if [[ ! -f "$csproj" ]]; then
		echo "Project file not found: $csproj" >&2
		echo "Current dir: $(pwd)" >&2
		echo "Tip: run from workspace root (where ./packages exists) or pass an explicit .csproj path." >&2
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

