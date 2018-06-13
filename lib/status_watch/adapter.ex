defmodule StatusWatch.Adapter do
  @callback update_status(%StatusWatch.Status{}) :: any
end
