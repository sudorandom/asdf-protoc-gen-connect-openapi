#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/sudorandom/protoc-gen-connect-openapi"
TOOL_NAME="protoc-gen-connect-openapi"
TOOL_TEST="protoc-gen-connect-openapi --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if protoc-gen-connect-openapi is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# TODO: Adapt this. By default we simply list the tag names from GitHub releases.
	# Change this function if protoc-gen-connect-openapi has other means of determining installable versions.
	list_github_tags
}

get_platform_and_arch() {
	local os arch
	os="$(uname -s | tr '[:upper:]' '[:lower:]')"
	arch="$(uname -m)"

	# Remap architecture to the one used in release assets
	case "$arch" in
	x86_64) arch="amd64" ;;
	aarch64) arch="arm64" ;;
	arm64) arch="arm64" ;;
	esac

	# Darwin releases are universal
	if [ "$os" = "darwin" ]; then
		echo "darwin_all"
		return
	fi

	# Handle Windows variants
	if [[ "$os" == "cygwin"* || "$os" == "msys"* || "$os" == "mingw"* ]]; then
		os="windows"
	fi

	# Check for supported combinations
	if { [ "$os" = "linux" ] || [ "$os" = "windows" ]; } && { [ "$arch" = "amd64" ] || [ "$arch" = "arm64" ]; }; then
		echo "${os}_${arch}"
	else
		fail "Unsupported OS-Arch combination: ${os}-${arch}"
	fi
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"
	local release_filename
	release_filename=$(basename "$filename")

	url="$GH_REPO/releases/download/v${version}/${release_filename}"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		# Find the downloaded file. There should be only one.
		local download_file
		download_file=$(find "$ASDF_DOWNLOAD_PATH" -type f -name "${TOOL_NAME}_${version}_*.tar.gz" | head -n 1)
		if [ -z "$download_file" ]; then
			fail "Could not find downloaded file for version $version in $ASDF_DOWNLOAD_PATH"
		fi

		mkdir -p "$install_path"
		tar -xzf "$download_file" -C "$install_path" || fail "Could not extract $download_file"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
