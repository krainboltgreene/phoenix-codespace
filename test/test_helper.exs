Mimic.copy(Core.Users)
Mimic.copy(Core.Data)
Mimic.copy(Core.Stories)
Mimic.copy(Core.Challenges)
Mimic.copy(Core.Universes)
Mimic.copy(Core.Job.GeneratePropertyJob)

{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Core.Repo, :manual)
