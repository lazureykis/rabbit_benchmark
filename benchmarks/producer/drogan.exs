# {"command": "hello", "type": "producer"}
# {"queue": "queue_1", "message": "TEST"}
{:ok, socket} = :gen_tcp.connect('localhost', 4444, [:binary, active: false, packet: :line])

hello_msg = ~s({"command":"hello","type":"producer"}\n)
msg_ok = ~s({"status":"ok"}\n)

:ok = :gen_tcp.send(socket, hello_msg)
{:ok, ^msg_ok} = :gen_tcp.recv(socket, 0, 1000)

post_message = fn ->
  0..1000
  |> Enum.each(fn n ->
    message = ~s({"queue":"log","message":"message #{n}"}\n)
    :ok = :gen_tcp.send(socket, message)
    {:ok, ^msg_ok} = :gen_tcp.recv(socket, 0)
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
