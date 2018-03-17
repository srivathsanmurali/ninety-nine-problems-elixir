defmodule NinetyNineProblems do
  @moduledoc """
  http://www.ic.unicamp.br/%7Emeidanis/courses/mc336/2009s2/prolog/problemas/
  """

  @doc """
    problem_01: returns the last element of the list
  """
  def last_element_list([]), do: {:error, "list is empty"}
  def last_element_list([x]), do: x
  def last_element_list([_x | xs]), do: last_element_list(xs)
  def last_element_list(_), do: {:error, "not a valid list"}

  @doc """
    problem_02: finds the last by one element of the list
  """
  def second_last_element_list([]), do: {:error, "list is empty"}
  def second_last_element_list(x) when is_list(x), do: problem_02_go(x, nil)
  def second_last_element_list([_x]), do: {:error, "only one element left"}
  def second_last_element_list(_), do: {:error, "not a valid list"}

  defp problem_02_go([_x | []], last_elem), do: last_elem
  defp problem_02_go([x | xs], _last_elem), do: problem_02_go(xs, x)

  @doc "problem_03: Find the kth element of the list"
  def kth_element_in_list([], _k), do: {:error, "list is empty"}
  def kth_element_in_list(x, k) when is_list(x), do: problem_03_go(x, 1, k)
  def kth_element_in_list(_, _), do: {:error, "not a valid list"}

  defp problem_03_go([], n, k) when n <= k, do: {:error, "length of list is less than k = #{k}"}
  defp problem_03_go([x | _xs], n, k) when n == k, do: x
  defp problem_03_go([_x | xs], n, k) when n < k, do: problem_03_go(xs, n + 1, k)

  @doc "problem_04: Find the number of elements in the list"
  def length_list([]), do: 0
  def length_list([_x | xs]), do: 1 + length_list(xs)
  def length_list(_), do: {:error, "not a valid list"}

  @doc "problem_05: Reverse a list"
  def reverse_list([]), do: []
  def reverse_list([x | xs]), do: reverse_list(xs) ++ [x]
  def reverse_list(_), do: {:error, "not a valid list"}

  @doc "problem_06: find out if a list is a palindrome"
  def palindrome_list?([]), do: {:error, "list is empty"}

  def palindrome_list?(x) when is_list(x) do
    x
    |> reverse_list()
    |> (fn y -> x == y end).()
  end

  @doc "problem_07: Flatten a list"
  def flatten_list([]), do: []
  def flatten_list(x) when not is_list(x), do: [x]
  def flatten_list([x | xs]), do: flatten_list(x) ++ flatten_list(xs)
  def flatten_list(_), do: {:error, "not a valid list"}

  @doc "problem_08: remove consecutive duplicates"
  def compress_list([]), do: []
  def compress_list([x]), do: [x]
  def compress_list([a, b | c]) when a == b, do: compress_list([b | c])
  def compress_list([a, b | c]), do: [a] ++ compress_list([b | c])
  def compress_list(_), do: {:error, "not a valid list"}

  @doc "problem_09: split list at consecutive elements"
  def pack([]), do: []
  def pack(x) when is_list(x), do: pack(x, [], [])
  defp pack([], rep, result), do: result ++ [rep]
  defp pack([x | xs], [], result), do: pack(xs, [x], result)

  defp pack([x | xs], [rep_head | rep_tail], result) when x == rep_head,
    do: pack(xs, [x, rep_head | rep_tail], result)

  defp pack([x | xs], rep, result), do: pack(xs, [x], result ++ [rep])

  @doc "encode the length of cosecutive elements"
  def encode(x) do
    x
    |> pack
    |> Enum.map(&encode_segment/1)
  end

  defp encode_segment([head | []]) do
    head
  end

  defp encode_segment([head | _tail] = x) do
    {length_list(x), head}
  end

  @doc "decode run length encoded list"
  def decode(x) do
    x
    |> Enum.map(&decode_segment/1)
    |> flatten_list
  end

  defp decode_segment(value) when not is_tuple(value), do: value
  defp decode_segment({num_repeat, value}), do: for(_ <- 1..num_repeat, do: value)

  def encode_direct([]), do: []
  def encode_direct(x) when is_list(x), do: encode_direct(x, {}, [])
  defp encode_direct([], rep, result), do: result ++ [rep]
  defp encode_direct([x | xs], {}, result), do: encode_direct(xs, x, result)

  defp encode_direct([x | xs], rep, result)
       when rep == x and not is_tuple(rep),
       do: encode_direct(xs, {2, rep}, result)

  defp encode_direct([x | xs], {num, rep}, result) when rep == x,
    do: encode_direct(xs, {num + 1, rep}, result)

  defp encode_direct([x | xs], rep, result), do: encode_direct(xs, x, result ++ [rep])

  @doc "duplicate elements of the list n times"
  def duplicate([], _), do: []

  def duplicate(list, num_duplicate),
    do: list |> Enum.map(&duplicate_elem(&1, num_duplicate)) |> flatten_list

  def duplicate(list), do: duplicate(list, 2)

  defp duplicate_elem(x, num_duplicate), do: for(_ <- 1..num_duplicate, do: x)

  @doc "drop every nth element"
  def drop(list, target_n), do: drop(list, target_n, 1)

  defp drop([], _target_n, _element_n), do: []

  defp drop([_head | tail], target_n, element_n)
       when target_n == element_n,
       do: drop(tail, target_n, 1)

  defp drop([head | tail], target_n, element_n), do: [head] ++ drop(tail, target_n, element_n + 1)

  @doc "slice a list using start and end indecies."
  def slice([], _, _), do: []
  def slice(x, start_index, end_index), do: slice(x, start_index, end_index, 1)
  defp slice([], _start_index, _end_index, _curr_index), do: []

  defp slice([_head | tail], start_index, end_index, curr_index)
       when curr_index < start_index or curr_index > end_index,
       do: slice(tail, start_index, end_index, curr_index + 1)

  defp slice([head | tail], start_index, end_index, curr_index),
    do: [head] ++ slice(tail, start_index, end_index, curr_index + 1)

  @doc "split the list at certain index"
  def split(list, split_index) do
    list_length = length_list(list)
    {slice(list, 1, split_index), slice(list, split_index + 1, list_length)}
  end

  @doc "rotate the list at certain index"
  def rotate(list, rotate_index) do
    {prefix, suffix} = split(list, rotate_index)
    suffix ++ prefix
  end

  @doc "problem_20: remove a spefic index"
  def remove(list, remove_index) do
    {prefix, [_head_suffix | tail_suffix]} = split(list, remove_index - 1)
    prefix ++ tail_suffix
  end

  @doc "problem_21: insert at a given index"
  def insert(list, target_index, value) do
    {prefix, suffix} = split(list, target_index - 1)
    prefix ++ [value] ++ suffix
  end

  @doc "problem_22: create a list given a range"
  def range(start_value, end_value) when end_value < start_value, do: []
  def range(start_value, end_value), do: [start_value] ++ range(start_value + 1, end_value)

  # @doc "problem_23: Extract a given number of randomly selected elements from a list."

end
