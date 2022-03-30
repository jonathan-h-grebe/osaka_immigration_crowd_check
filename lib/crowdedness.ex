defmodule Crowdedness do
  @moduledoc """
  A struct representing one instants data of crowdedness,
  for any of：
  ・在留・認定申請
  ・許可証印
  ・許可証印
  ・行政相談
  ・永住者在留カード有効期間更新
  ・その他
  """

  use TypedStruct

  typedstruct do
    field(:calling, non_neg_integer())
    field(:called, list(non_neg_integer()))
    field(:waiting, non_neg_integer())
  end
end
