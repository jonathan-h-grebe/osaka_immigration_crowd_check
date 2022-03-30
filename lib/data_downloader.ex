defmodule DataDownloader do
  @url_for_data "http://omatase.jp/h81000/index.php"

  @application_nth_td 0
  @permission_nth_td 4
  @residence_card_nth_td 8
  @consultation_nth_td 12
  @permanent_residence_nth_td 16
  @other_nth_td 20

  @calling_nth_td 1
  @called_nth_td 2
  @waiting_nth_td 3

  alias RegularTask.{Repo, CrowdStat}

  @doc """
    Get the latest data about the crowdedness of immigration,
    save it as one record in the database.
  """
  def call do
    try do
      req_res = HTTPoison.get!(@url_for_data)
      parsed_html = Floki.parse_document!(req_res.body)
      found_tds = Floki.find(parsed_html, "td")

      applications = get_info(found_tds, @application_nth_td)
      permissions = get_info(found_tds, @permission_nth_td)
      residence_cards = get_info(found_tds, @residence_card_nth_td)
      consultations = get_info(found_tds, @consultation_nth_td)
      permanent_residences = get_info(found_tds, @permanent_residence_nth_td)
      others = get_info(found_tds, @other_nth_td)

      db_insert_res =
        CrowdStat.from(
          applications,
          permissions,
          residence_cards,
          consultations,
          permanent_residences,
          others
        )
        |> Repo.insert()
      case db_insert_res do
        {:ok, _} ->
          IO.puts("Succesfully inserted entry to DB")
          :ok
        error ->
          IO.puts("Failed to insert entry to DB. Details: #{inspect(error)}")
          :error
      end
    rescue
      exception -> IO.puts("Exception occured when downloading data. Details: #{inspect(exception)}")
    end

  end

  @doc """
    For one of the services (applications, consultations etc),
    return calling, called and waiting as struct.
  """
  @spec get_info(list(Floki.html_node()), non_neg_integer()) :: Crowdedness.t()
  def get_info(found_tds, starting_nth_td) do
    %Crowdedness{
      calling: Enum.fetch!(found_tds, starting_nth_td + @calling_nth_td) |> extract_text(),
      called: Enum.fetch!(found_tds, starting_nth_td + @called_nth_td) |> extract_text(),
      waiting: Enum.fetch!(found_tds, starting_nth_td + @waiting_nth_td) |> extract_text()
    }
  end

  @doc """
    Get text out of html node representing tuple.
  """
  @spec extract_text({Floki.html_node(), list(Floki.html_attribute()), Floki.html_node()}) ::
          binary()
  defp extract_text({_, _, [text]}), do: text
  defp extract_text({_, _, []}), do: ""
end
