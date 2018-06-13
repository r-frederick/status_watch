defmodule StatusWatch.SlackAdapter do
  @baseurl "https://slack.com/api"
  @status_path "/users.profile.set"
  @behaviour StatusWatch.Adapter
  alias StatusWatch.Status

  def update_status(%Status{} = status) do
    response = HTTPoison.post(build_url(), build_body!(status), build_headers())

    case response do
      {:ok, %{body: body, status_code: 200}} -> {:ok, Poison.decode!(body)}
      _ -> {:error}
    end
  end

  defp build_url do
    "#{@baseurl}#{@status_path}"
  end

  defp build_headers do
    api_key = Application.get_env(:status_watch, SlackAdapter)
      |> Keyword.fetch!(:api_key)

    [{"Content-Type", "application/json"}, {"Authorization", "Bearer #{api_key}"}]
  end

  defp build_body!(%Status{} = status) do
    %{profile: status}
    |> Poison.encode!()
  end
end
