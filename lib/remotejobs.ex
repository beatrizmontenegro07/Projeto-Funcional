defmodule Remotejobs do
  @url "https://jobicy.com/api/v2/remote-jobs?count=20&geo=brazil"

  def get do
    HTTPoison.get(@url)
    |> process_response
  end

  defp process_response({ :ok, %HTTPoison.Response{ status_code: 200, body: b}}) do
    { :ok, b}
  end

  defp process_response({ :error, r}), do: { :error, r}

  defp process_response({ :ok, %HTTPoison.Response{ status_code: _, body: b}}) do
    { :error, b}
  end

end
