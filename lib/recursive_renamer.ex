defmodule RecursiveRenamer do
  @moduledoc """
   RecursiveRenamer renames all folder/files based on the rules:
  1. lowercase
  2. now multiple multispaces
  2. empty spaces -> dash
  3. Add your
  """
  def ls_r(path \\ ".") do
    cond do
      File.regular?(path) ->
        [path]

      File.dir?(path) ->
        File.ls!(path)
        |> Enum.map(&Path.join(path, &1))
        |> Enum.map(&ls_r/1)
        |> Enum.concat()

      true ->
        []
    end
  end

  defp format_path(path, current_folder_name, new_folder) do
    destination_folder_name = if new_folder, do: new_folder, else: "new_#{current_folder_name}"

    path
    |> String.replace(current_folder_name, destination_folder_name)
    |> String.replace(~r/-|—/, " ")
    |> String.replace(~r/\s\s+/, " ")
    |> String.replace(" ", "-")
    |> String.downcase()
  end

  defp format_path(path, current_folder_name, new_folder, cb) do
    path
    |> format_path(current_folder_name, new_folder)
    |> cb.()
  end

  defp create_folder(new_path) do
    with {_file, path} <- new_path |> String.split("/") |> List.pop_at(-1),
         formatted_path <- Enum.join(path, "/"),
         false <- File.exists?(formatted_path),
         :ok <- File.mkdir_p(formatted_path) do
      IO.inspect("Creating Folder #{formatted_path}")
      new_path
    else
      true -> new_path
    end
  end

  def run(folder_path, new_folder_name, ignore \\ [], format_cb \\ &return_value/1) do
    current_folder_name = Path.basename(folder_path)
    folder_path
    |> ls_r()
    |> Enum.filter(fn item -> !String.contains?(item, ignore) end)
    |> Enum.map(fn item ->
      destination_path =
        item |> format_path(current_folder_name, new_folder_name, format_cb) |> create_folder()

      with :ok <- File.cp(item, destination_path) do
        IO.inspect("File saved! #{destination_path}")
        :ok
      else
        error ->
          IO.inspect("Error during saving file #{inspect(error)}")
          error
      end
    end)
  end

  def return_value(value), do: value
end
