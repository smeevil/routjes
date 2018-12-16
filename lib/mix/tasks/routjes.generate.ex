defmodule Mix.Tasks.Routjes.Generate do
  @moduledoc """
  A simple mix task to kick off the routjes generator
  """

  use Mix.Task

  @shortdoc "(Re)generate routjes js file"
  @spec run(binary | nil) :: {:ok, binary} | no_return
  def run([scope| _rest]), do: Routjes.generate(scope)
  def run(_args), do: Routjes.generate()
end
