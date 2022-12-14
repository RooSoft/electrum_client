defmodule ElectrumClient.Endpoint do
  def request(params, socket) do
    :ok = :gen_tcp.send(socket, params)

    socket
    |> receive_response()
  end

  defp receive_response(socket) do
    {:ok, response} = receive_response(socket, "")

    response
  end

  defp receive_response(socket, buffer) do
    {:ok, message} = :gen_tcp.recv(socket, 0)

    buffer = buffer <> message

    case String.ends_with?(message, "\n") do
      true -> try_parse_result(buffer)
      false -> receive_response(socket, buffer)
    end
  end

  defp try_parse_result(message) do
    case Jason.decode(message) do
      {:ok, %{"result" => response}} -> {:ok, response}
      {:error, message} -> {:error, message}
    end
  end
end
