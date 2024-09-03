defmodule Api do
  def main(args) do
    IO.puts("Do you want to see the most recent job offers or perform a targeted search?")
    IO.puts("1. Most recent job offers")
    IO.puts("2. Targeted search")
    choice = IO.gets("Enter your choice (1 or 2): ") |> String.trim()

    case choice do
      "1" ->
        Remotejobs.get_recent()
        |> show_result()

      "2" ->
        filters = get_filters()
        Remotejobs.get(filters)
        |> show_result()

      _ ->
        IO.puts("Invalid choice, please enter 1 or 2.")
        main(args)  # Restart the process if the input is invalid
    end
  end

  defp get_filters do
    IO.puts("Enter job count (example: 5):")
    count = IO.gets("") |> String.trim()
    count = if count == "", do: 10, else: String.to_integer(count)

    IO.puts("Enter search region (example: usa, brazil):")
    geo = IO.gets("") |> String.trim()
    geo = if geo == "", do: "brazil", else: geo

    IO.puts("Enter job industry (example: dev) or press Enter to skip:")
    industry = IO.gets("") |> String.trim()

    IO.puts("Enter job tag (example: python) or press Enter to skip:")
    tag = IO.gets("") |> String.trim()

    %{
      count: count,
      geo: geo,
      industry: industry,
      tag: tag
    }
  end

  defp show_result({:error, _}) do
    IO.puts("An error occurred")
  end

  defp show_result({:ok, json}) do
    {:ok, jobs} = Poison.decode(json)
    job_list = jobs["jobs"]

    if length(job_list) > 0 do
      cabecalho =
        "#{String.pad_trailing("ID", 8)}" <>
        "#{String.pad_trailing("Company", 15)}" <>
        "#{String.pad_trailing("Title", 45)}" <>
        "#{String.pad_trailing("Industry", 25)}" <>
        "#{String.pad_trailing("Level", 10)}" <>
        "#{String.pad_trailing("Type", 15)}" <>
        "#{String.pad_trailing("Pub Date", 0)}\n"

      IO.puts cabecalho
      show_jobs(job_list)
      consultJob(job_list)
    else
      IO.puts("No jobs found.")
    end
  end

  defp show_jobs([]), do: []
  defp show_jobs([job | rest]) do
    id = job["id"] || "N/A"
    company = job["companyName"] || "N/A"
    title = job["jobTitle"] || "N/A"
    industry = Enum.join(job["jobIndustry"], ", ") || "N/A"
    level = job["jobLevel"] || "Any"
    type = Enum.join(job["jobType"], ", ") || "N/A"
    pub_date = job["pubDate"] |> String.slice(0..9) || "N/A"

    texto =
      "#{String.pad_trailing(to_string(id), 8)}" <>
      "#{String.pad_trailing(company, 15)}" <>
      "#{String.pad_trailing(title, 45)}" <>
      "#{String.pad_trailing(industry, 25)}" <>
      "#{String.pad_trailing(level, 10)}" <>
      "#{String.pad_trailing(type, 15)}" <>
      "#{String.pad_trailing(pub_date, 0)}"

    IO.puts(texto)
    show_jobs(rest)
  end

  defp consultJob(job_list) do
    IO.puts("\nDo you want more information about a job? [Y/N]")
    ans = IO.gets("") |> String.upcase() |> String.trim()

    cond do
      ans == "Y" ->
        IO.puts("\nEnter the ID of the job you want more information about: ")
        id = IO.gets("") |> String.trim()
        job = Enum.find(job_list, fn job -> to_string(job["id"]) == id end)

        case job do
          nil ->
            IO.puts("Job not found!")
          _ ->
            IO.puts("More information at: #{job["url"]}")
        end

        consultJob(job_list)

      ans == "N" ->
        IO.puts("Exiting...")
        :ok

      true ->
        IO.puts("Enter a valid value!")
        consultJob(job_list)
    end
  end
end
