defmodule StatusWatchTest do
  use ExUnit.Case
  doctest StatusWatch

  test "greets the world" do
    assert StatusWatch.hello() == :world
  end
end
