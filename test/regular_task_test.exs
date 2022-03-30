defmodule RegularTaskTest do
  use ExUnit.Case
  doctest RegularTask

  test "greets the world" do
    assert RegularTask.hello() == :world
  end
end
