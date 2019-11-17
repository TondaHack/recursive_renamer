# Recursive Renamer

Tool for recursive renaming folders, files for you assets.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `recursive_renamer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:recursive_renamer, "~> 0.1.0"}
  ]
end
```

## Usage

### Simple usage
```
RecursiveRenamer.run("../source", "name_of_destination_folder")
```
### Ignore files
```
RecursiveRenamer.run("../source", "name_of_destination_folder", [".DS_Store", "other_string_included_in_the name"])
```

### Own formatters
```
defmodule MyApplication do
  def custom_format(path) do 
    String.replace(path, "test_", "")
  end
end

RecursiveRenamer.run("../source", "name_of_destination_folder", [], &MyApplication,.custom_format/1)
```




### Mix tasks

```
mix rename "../source" "name_of_destination_folder"
```



Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/recursive_renamer](https://hexdocs.pm/recursive_renamer).

