require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Invalid registration code" do
    u = User.new({:registration_code => "ergejklrglekjhrg43t4t"})
    assert !u.valid?
    assert u.errors[:registration_code].count == 1
  end

  test "Valid registration code" do
    u = User.new({:registration_code => "AAA"})
    u.valid?
    assert u.errors[:registration_code].count == 0
  end

  test "Used registration code" do
    u = User.new({:registration_code => "BBB"})
    assert !u.valid?
    assert u.errors[:registration_code].count == 2, "Expecting two errors for a used registration code"
  end

  test "Used registration code on existing user valid" do
    u = User.find(22)
    #assert u.valid?
    u.valid?
    assert u.errors[:registration_code].count == 0, "Expecting no errors on an existing user with a used registration code"
  end

  test "creating new user also creates userwords" do
    # Check integrity of data before test
    assert UserWord.count == (User.count * Word.count), "Bad fixture data! Can't run this test"

    user = User.new(:email => "email@test.com", :registration_code => "AAA", :password => "oneoneone", :password_confirmation => "oneoneone")
    user.save!

    assert (user.user_words.count == Word.count), "Number of user words for this user does not match number of words"
  end

  test "delete user also deletes associated userwords" do
    assert UserWord.count == (User.count * Word.count), "Bad fixture data! Can't run this test"

    user = User.find(22)
    user.destroy

    assert UserWord.count <= (User.count * Word.count), "Userwords not deleted"
    assert UserWord.count >= (User.count * Word.count), "Too many userwords were deleted"
  end

  test "user takes on role of registration code" do
    tester_code = RegistrationCode.generate(:tester)
    participant_code = RegistrationCode.generate(:participant)
    admin_code = RegistrationCode.generate(:admin)
    teacher_code = RegistrationCode.generate(:teacher)

    tester_code.save
    participant_code.save
    admin_code.save
    teacher_code.save

    tester = User.new(:email => "test1@test.com", :password => "pwdpwdpwd", :password_confirmation => "pwdpwdpwd")
    participant = User.new(:email => "test2@test.com", :password => "pwdpwdpwd", :password_confirmation => "pwdpwdpwd")
    admin = User.new(:email => "test3@test.com", :password => "pwdpwdpwd", :password_confirmation => "pwdpwdpwd")
    teacher = User.new(:email => "test4@test.com", :password => "pwdpwdpwd", :password_confirmation => "pwdpwdpwd")

    tester.registration_code = tester_code.code
    participant.registration_code = participant_code.code
    admin.registration_code = admin_code.code
    teacher.registration_code = teacher_code.code

    assert (tester.role.tester?)
    assert (participant.role.participant?)
    assert (admin.role.admin?)
    assert (teacher.role.teacher?)

    tester.save
    participant.save
    admin.save
    teacher.save

    assert (tester.role.tester?)
    assert (participant.role.participant?)
    assert (admin.role.admin?)
    assert (teacher.role.teacher?)
  end
end
