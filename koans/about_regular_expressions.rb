# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutRegularExpressions < Neo::Koan
  def test_a_pattern_is_a_regular_expression
    assert_equal Regexp, /pattern/.class
  end

  def test_a_regexp_can_search_a_string_for_matching_content
    assert_equal "match", "some matching content"[/match/]
    # match the word "match" in string "some matching content"
  end

  def test_a_failed_match_returns_nil
    assert_equal nil, "some matching content"[/missing/]
    # there is no "missing" in "some matching content"
  end

  # ------------------------------------------------------------------

  def test_question_mark_means_optional
    assert_equal "ab", "abbcccddddeeeee"[/ab?/] # match a following b with 0 or one time; 1 b
    assert_equal "a", "abbcccddddeeeee"[/az?/] # match a following z with 0 or one time; no z
  end

  def test_plus_means_one_or_more
    assert_equal "bccc", "abbcccddddeeeee"[/bc+/] # match b following c with 1 or more time; 3c
  end

  def test_asterisk_means_zero_or_more
    assert_equal "abb", "abbcccddddeeeee"[/ab*/] #match a following b with 0 or more time; 2b
    assert_equal "a", "abbcccddddeeeee"[/az*/] # math a following z with 0 or more time; no z
    assert_equal "", "abbcccddddeeeee"[/z*/] 
    # match z with 0 or more time; no z but still return "" not nil cuz still match

    # THINK ABOUT IT:
    #
    # When would * fail to match?
  end

  # THINK ABOUT IT:
  #
  # We say that the repetition operators above are "greedy."
  #
  # Why?

  # ------------------------------------------------------------------

  def test_the_left_most_match_wins
    assert_equal "a", "abbccc az"[/az*/] 
    # match a following z with 0 or more time, match once only start from left
  end

  # ------------------------------------------------------------------

  def test_character_classes_give_options_for_a_character
    animals = ["cat", "bat", "rat", "zat"]
    assert_equal ["cat", "bat", "rat"], animals.select { |a| a[/[cbr]at/] }
    #  /[cbr]at/ match c or b or r following by at
  end

  def test_slash_d_is_a_shortcut_for_a_digit_character_class
    assert_equal "42", "the number is 42"[/[0123456789]+/]
    # /[0123456789]+/ match either one of these number with one more time
    assert_equal "42", "the number is 42"[/\d+/]
    # /\d+/ same as /[0123456789]+/ match any digit with 1 or more time
  end

  def test_character_classes_can_include_ranges
    assert_equal "42", "the number is 42"[/[0-9]+/]
    # /[0-9]+/ match any number from 0 to 9 with 1 or more time

  end

  def test_slash_s_is_a_shortcut_for_a_whitespace_character_class
    assert_equal " \t\n", "space: \t\n"[/\s+/] # match any space with 1 more time (\t and \n are also space)
  end

  def test_slash_w_is_a_shortcut_for_a_word_character_class
    # NOTE:  This is more like how a programmer might define a word.
    assert_equal "variable_1", "variable_1 = 42"[/[a-zA-Z0-9_]+/]
    # match any letter (both upper and lowercase), or any number  from 0-9 or _ with one or more time
    assert_equal "variable_1", "variable_1 = 42"[/\w+/] # shortcut
    # /\w/ == /[a-zA-Z0-9_]/
  end

  def test_period_is_a_shortcut_for_any_non_newline_character
    assert_equal "abc", "abc\n123"[/a.+/] 
    # match a following any character(including numbers and symbols) except new line
  end

  def test_a_character_class_can_be_negated
    assert_equal "the number is ", "the number is 42"[/[^0-9]+/]
    # match anything except number from 0-9 with one or more
  end

  def test_shortcut_character_classes_are_negated_with_capitals
    assert_equal "the number is ", "the number is 42"[/\D+/] # /\D/ shortcut for /[^0-9]/
    assert_equal "space:", "space: \t\n"[/\S+/] # match anything not white space with one ore more time
    # ... a programmer would most likely do
    assert_equal " = ", "variable_1 = 42"[/[^a-zA-Z0-9_]+/]
    #  match anything is not letter a - z or A - Z or number 0 - 9 or _ with one or more time
    assert_equal " = ", "variable_1 = 42"[/\W+/]
    # /\W+/ is shortcut for /[^a-zA-Z0-9_]+/
  end

  # ------------------------------------------------------------------

  def test_slash_a_anchors_to_the_start_of_the_string
    assert_equal "start", "start end"[/\Astart/]
    # match "start" from beginning of the string
    assert_equal nil, "start end"[/\Aend/]
    # match "end" from beginning of the string >> no match >> nil
  end

  def test_slash_z_anchors_to_the_end_of_the_string
    assert_equal "end", "start end"[/end\z/]
    # match "end" from the end of the string
    # if use Z intead of z: meaning Matches end of string. If a newline exists, it matches just before newline.
    assert_equal nil, "start end"[/start\z/]
    # match "start" from the end of the string >> no match >> nil
  end

  def test_caret_anchors_to_the_start_of_lines
    assert_equal "2", "num 42\n2 lines"[/^\d+/]
    # matching a digit with one or more time starting at new line
  end

  def test_dollar_sign_anchors_to_the_end_of_lines
    assert_equal "42", "2 lines\nnum 42"[/\d+$/]
    # matching a digit with one or more time at the end of new line
  end

  def test_slash_b_anchors_to_a_word_boundary
    assert_equal "vines", "bovine vines"[/\bvine./]
    # matching "vine" following by any character except new line >> be careful when using \b
  end

  # ------------------------------------------------------------------

  def test_parentheses_group_contents
    assert_equal "hahaha", "ahahaha"[/(ha)+/] # match "ha" with one or more time
  end

  # ------------------------------------------------------------------

  def test_parentheses_also_capture_matched_content_by_number
    assert_equal "Gray", "Gray, James"[/(\w+), (\w+)/, 1]
    assert_equal "James", "Gray, James"[/(\w+), (\w+)/, 2]
    # "Gray, James, John"[/(\w+), (\w+), (\w+)/, 3]  => "John"
  end

  def test_variables_can_also_be_used_to_access_captures
    assert_equal "Gray, James", "Name:  Gray, James"[/(\w+), (\w+)/]
    assert_equal "Gray", $1 # kind of understand but need more explantion
    assert_equal "James", $2
  end

  # ------------------------------------------------------------------

  def test_a_vertical_pipe_means_or
    grays = /(James|Dana|Summer) Gray/
    assert_equal "James Gray", "James Gray"[grays] # match James or Dana or Summer following Gray, if no number, 0 is default
    assert_equal "Summer", "Summer Gray"[grays, 1] # the number is the order of the group, if 0 return whole match
    assert_equal nil, "Jim Gray"[grays, 1] 
  end

  #note
  #  /(?<first>\w+) (?<last>\w+)/.match("Trung Huynh") => "Trung Huynh"
  #  /(?<first>\w+) (?<last>\w+)/.match("Trung Huynh")["first"] => "Trung"
  #  /(?<first>\w+) (?<last>\w+)/.match("Trung Huynh")["last"] => "Huynh"

  # THINK ABOUT IT:
  #
  # Explain the difference between a character class ([...]) and alternation (|).

  # ------------------------------------------------------------------

  def test_scan_is_like_find_all
    assert_equal ["one", "two", "three"], "one two-three".scan(/\w+/)
  end

  def test_sub_is_like_find_and_replace
    assert_equal "one t-three", "one two-three".sub(/(t\w*)/) { $1[0, 1] }
    # replace t following 0 or more word character with the first value of that match, do once
    # in this case replace two with t (this t is from two)
  end

  def test_gsub_is_like_find_and_replace_all
    assert_equal "one t-t", "one two-three".gsub(/(t\w*)/) { $1[0, 1] }
    # replace t following 0 or more word character with the first value of that match, do all
    # in this case replace two with t (this t is from two), three with t (this t is from three)
  end
end
