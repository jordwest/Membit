require 'test_helper'

class WordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "creating new word also creates userword" do
    # Check integrity of data before test
    assert UserWord.count == (User.count * Word.count), "Bad fixture data! Can't run this test"

    new_word = Word.new(:meaning => "Location")
    new_word.save

    assert (new_word.user_words.count == User.count), "Number of user words for this word does not match number of users"
  end

  test "delete word also deletes associated userwords" do
    assert UserWord.count == (User.count * Word.count), "Bad fixture data! Can't run this test"

    word = Word.find(1)
    word.destroy

    assert UserWord.count <= (User.count * Word.count), "Userwords not deleted"
    assert UserWord.count >= (User.count * Word.count), "Too many userwords were deleted"
  end
end
