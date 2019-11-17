defmodule Mix.Tasks.Rename do
  use Mix.Task

  @shortdoc "Recursive assets renaming"
  def run(args) do
    folder_path = Enum.at(args, 0)
    new_folder_name = Enum.at(args, 1)
    ignore = Enum.at(args, 2, [])

    RecursiveRenamer.run(folder_path, new_folder_name, ignore)
  end
end
