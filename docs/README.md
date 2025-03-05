## Why

while there are existing & excellent implementations of this by [@tmatilai](https://github.com/tmatilai/direnv-1password) & [@venkytv](https://github.com/venkytv/direnv-op) which I used to reference my implementation, they however compromise in some key areas (for my needs)

<details>
<summary>compromises in other implementations</summary>

> [!NOTE]  
> These are just my opinions/preferences, and not a criticism of those implementations.

#### `tmatilai/direnv-1password`:
1. relying on `heredoc` to load multiple secrets:  
  Distracting when editing / reviewing `.envrc` files and pollutes the syntax.

2. loading one secret at a time with `from_op`:  
  Will cause noticeable delay when you using with multiple entries.

#### `venkytv/direnv-op`

1. uses a separate file altogether `.oprc`:  
  Less is more!
2. relies on [`watch_file`](https://direnv.net/man/direnv-stdlib.1.html#codewatchfile-ltpathgt-ltpathgt-code):  
  Extra resource usage on your system
</details>


## Usage

1. declare any environment variables using [secret reference syntax](https://developer.1password.com/docs/cli/secret-reference-syntax/) 
2. run `1password` extension (once)

<!-- eslint-disable markdown/heading-increment -->
###### `.envrc`

```shell
# declare any environment variables using secret reference syntax 
export MY_SECRET="op://vault-name/item-name/field"
export MY_OTHER_SECRET="op://vault-name/item-name/section-name/field"

# run 1password
1password
```

### Config 

1. specify 1Password account using `OP_ACCOUNT` env
2. custom path to 1Password CLI using `OP_CLI` env _(useful when using with WSL passthrough to `op.exe`)_

```shell
export OP_CLI="op.exe"
export OP_ACCOUNT="my-1p-account"

eval "$(direnv hook bash)"
```

## How

The execution workflow:

below is a simplified version of: [`1password.sh`](/1password.sh)

```shell
eval "$(direnv dotenv bash <(echo "$(printenv | grep "op://")" | op inject))"
```

1. direnv will assign values as-is to env using the `op://` syntax
2. `printenv | grep "op://")` filters the current env for just `op://` values
3. pass those values to [`op inject`](https://developer.1password.com/docs/cli/reference/commands/inject/)
4. inject back to direnv using [`dotenv bash`]

### Other Shells?

I only use `bash`, and this workflow requires `bash` as such I have not tested with other shells, please share your experience / suggestions / pull-requests if you find a gap in execution in other shells.

