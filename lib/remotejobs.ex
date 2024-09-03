defmodule Remotejobs do
  @base_url "https://jobicy.com/api/v2/remote-jobs"

  def get_recent do
    url = "#{@base_url}?count=20&geo=brazil"
    HTTPoison.get(url)
    |> process_response()
  end

  def get(filters) do
    url = build_url(filters)
    HTTPoison.get(url)
    |> process_response()
  end

  defp build_url(%{count: count, geo: geo, industry: industry, tag: tag}) do
    url = "#{@base_url}?count=#{count}&geo=#{geo}"
    
    url =
      if industry != "", do: "#{url}&industry=#{industry}", else: url
    
    if tag != "", do: "#{url}&tag=#{tag}", else: url
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, body}
  end

  defp process_response({:error, reason}), do: {:error, reason}

  defp process_response({:ok, %HTTPoison.Response{status_code: _, body: body}}) do
    {:error, body}
  end
end
