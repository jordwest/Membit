require 'test_helper'

class RegistrationCodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Generates code" do
    code = RegistrationCode.generate(:participant)
    assert code.code.length == 10, "Not 10 digits"
  end

  test "Saves code" do
    code = RegistrationCode.generate(:participant).save
    assert !code.nil?, "Code not saved"
  end

  test "Cant save code with missing printed" do
    code = RegistrationCode.generate(:participant)
    code.update_attributes({:printed => nil})
    assert !code.save, "Code saved when it shouldn't have"
  end
end
