<div align="center">

# asdf-protoc-gen-connect-openapi [![Build](https://github.com/sudorandom/asdf-protoc-gen-connect-openapi/actions/workflows/build.yml/badge.svg)](https://github.com/sudorandom/asdf-protoc-gen-connect-openapi/actions/workflows/build.yml) [![Lint](https://github.com/sudorandom/asdf-protoc-gen-connect-openapi/actions/workflows/lint.yml/badge.svg)](https://github.com/sudorandom/asdf-protoc-gen-connect-openapi/actions/workflows/lint.yml)

[protoc-gen-connect-openapi](https://github.com/sudorandom/protoc-gen-connect-openapi) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add protoc-gen-connect-openapi
# or
asdf plugin add protoc-gen-connect-openapi https://github.com/sudorandom/asdf-protoc-gen-connect-openapi.git
```

protoc-gen-connect-openapi:

```shell
# Show all installable versions
asdf list all protoc-gen-connect-openapi

# Install specific version
asdf install protoc-gen-connect-openapi latest

# Set a version globally (on your ~/.tool-versions file)
asdf global protoc-gen-connect-openapi latest

# Now protoc-gen-connect-openapi commands are available
protoc-gen-connect-openapi --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/sudorandom/asdf-protoc-gen-connect-openapi/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Kevin McDonald](https://github.com/sudorandom/)
