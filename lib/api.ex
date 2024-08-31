defmodule Api do

  @spec get_jobs() :: any()
  def get_jobs() do
    Remotejobs.get()
    |> show_result
  end

  defp show_result({ :error, _}) do
    IO.puts "Ocorreu um erro"
  end

  defp show_result({ :ok, json}) do
    { :ok, jobs} = Poison.decode(json)
    job_list = jobs["jobs"]
    cabecalho =
      "#{String.pad_trailing("ID", 8)}\
      #{String.pad_trailing("Company", 15)}\
      #{String.pad_trailing("Title", 45)}\
      #{String.pad_trailing("Industry", 25)}\
      #{String.pad_trailing("Level", 6)}\
      #{String.pad_trailing("Type", 10)}\
      #{String.pad_trailing("Pub Date", 0)}\n"
    IO.puts cabecalho
    show_jobs(job_list)
  end

  defp show_jobs([]), do: []
  defp show_jobs([job | rest]) do
    id = job["id"]
    company = job["companyName"]
    title = job["jobTitle"]
    industry = job["jobIndustry"]
    level = job["jobLevel"]
    type = job["jobType"]
    pub_date = job["pubDate"] |> String.slice(0..9)

    texto =
      "#{String.pad_trailing(to_string(id), 8)}\
      #{String.pad_trailing(company, 15)}\
      #{String.pad_trailing(title, 45)}\
      #{String.pad_trailing(Enum.join(industry, ", "), 25)}\
      #{String.pad_trailing(to_string(level), 6)}\
      #{String.pad_trailing(to_string(type), 10)}\
      #{String.pad_trailing(to_string(pub_date), 0)}"

    IO.puts(texto)
    show_jobs(rest)
  end

end
