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
    show_jobs(job_list)
  end

  defp show_jobs([]), do: nil
  defp show_jobs([job | rest]) do
    id = job["id"]
    company = job["companyName"]
    title = job["jobTitle"]
    industry = job["jobIndustry"]
    level = job["jobLevel"]
    type = job["jobType"]
    pub_date = job["pubDate"]
    IO.puts "#{id}  |  #{company}  |  #{industry}  |  #{title}  |  #{level}  |  #{type}  |  #{pub_date}"
    show_jobs(rest)
  end

end
