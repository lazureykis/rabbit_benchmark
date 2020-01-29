{:ok, socket} = :gen_tcp.connect('localhost', 4040, [:binary, active: false, packet: :line])

hello_msg = ~s(hello producer\n)
msg_ok = "Message published\n"

:ok = :gen_tcp.send(socket, hello_msg)
{:ok, "Producer registered\n"} = :gen_tcp.recv(socket, 0, 1000)

post_message = fn ->
  0..1000
  |> Enum.each(fn n ->
    message = ~s(push log message_#{n}\n)
    :ok = :gen_tcp.send(socket, message)
    {:ok, ^msg_ok} = :gen_tcp.recv(socket, 0, 1000)
  end)
end

Benchee.run(
  %{
    "post_message" => post_message
    # "test" => fn -> 1 + 1 end
  },
  warmup: 0,
  time: 10,
  memory_time: 0
)
