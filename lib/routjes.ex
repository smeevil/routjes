defmodule Routjes do
  @moduledoc """
  This module will take care of extracting the current routes from your phoenix endpoint and write them out in either a
  javascript(.js) or typescript(.ts) file. Depending on the extension given in the output_file configuration.
  """

  @spec generate() :: {:ok, binary} | no_return
  def generate() do
    get_config()
    |> check_config()
    |> maybe_start_end_point()
    |> generate_script()
  end

  @spec get_config() :: map
  defp get_config do
    Enum.into(
      [:router, :end_point, :output_dir, :output_file],
      %{},
      &{&1, Application.get_env(:routjes, &1)}
    )
  end

  @spec check_config(map) :: map | no_return
  defp check_config(config) do
    config
    |> Map.values()
    |> Enum.all?(&(not is_nil(&1)))
    |> case do
         true -> check_directory!(config)
         _ -> raise_configuration_message!()
       end
  end

  @spec generate_script(map) :: {:ok, binary} | no_return
  defp generate_script(config) do

    file_location = config.output_dir <> "/" <> config.output_file
    routes = Enum.reduce(config.router.__routes__, %{}, &parse(&1, &2))

    template =
      if String.ends_with?(config.output_file, ".ts"), do: "typescript", else: "javascript"

    :ok =
      File.write(
        file_location,
        EEx.eval_file(
          "#{__DIR__}/templates/#{template}.eex",
          [host: config.end_point.url, routes: routes],
          trim: true
        )
      )

    IO.puts("routjes written to #{inspect(String.replace(file_location, File.cwd!(), ""))} :) ")
    {:ok, file_location}
  end

  @spec check_directory!(map) :: no_return | map
  defp check_directory!(%{output_dir: dir} = config) do
    if !File.exists?(dir),
       do:
         raise(
           """
           Output directory '#{dir}' configured for Routjes does not exist, please double check your configuration!
           """
         )
    config
  end

  @spec parse(map, map) :: map
  defp parse(%{helper: helper, opts: action, path: path}, map) when not is_nil(helper) do
    generate_function_name(helper, action)
    add_key(map, helper, action, path)
  end

  defp parse(_route, map), do: map

  @spec generate_function_name(binary, binary) :: binary
  defp generate_function_name(helper, action), do: Macro.camelize("#{helper}_#{action}")

  @spec add_key(map, binary, binary, binary) :: map
  def add_key(map, helper, action, path) do
    args = extract_args_from(path)
    key = Macro.camelize("#{helper}_#{action}")
    Map.put_new(map, key, %{path: path, args: args})
  end

  @spec extract_args_from(binary) :: [binary]
  defp extract_args_from(path) do
    path
    |> String.split("/")
    |> Enum.reduce([], &filter_args(&1, &2))
    |> Enum.reverse()
  end

  @spec filter_args(binary, list) :: [binary]
  defp filter_args(":" <> item, list), do: [String.replace(item, ":", "") | list]
  defp filter_args(_item, list), do: list

  @spec raise_configuration_message! :: no_return
  defp raise_configuration_message! do
    raise """

    Invalid or missing configuration for Routjes.
    Please add the following configuration to your config/config.exs

    config :routjes,
      output_dir: __DIR__ <> "/../assets/js",
      output_file: "routjes.ts",
      router: MyApp.Web.Router,
      end_point: MyApp.Web.Endpoint
    """
  end

  # When running as mix task, the endpoint might not be running. We can check that by seeing of the ETS table responds.
  # If ran from the root of umbrella apps we only need to check the ets lookup
  # If ran in the umbrella app itself we check if the code is compiled otherwise we run the app.start mix task
  @spec maybe_start_end_point(map) :: map
  defp maybe_start_end_point(config) do
    try do
      :ets.lookup(config.end_point, :__phoenix_url__)
    rescue
      _ ->
        if !Code.ensure_compiled?(config.end_point), do: Mix.Task.run("app.start")
        config.end_point.start_link
    end

    config
  end
end
