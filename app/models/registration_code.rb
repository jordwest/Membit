class RegistrationCode < ActiveRecord::Base
  validates_uniqueness_of :code
  validates_presence_of :code, :role

  classy_enum_attr :role

  scope :unprinted, where('printed is not ?', true)

  # @param [Symbol] role The role that the created user will be given
  def self.generate(role)
    newCode = self.new
    newCode.role = role
    newCode.used = false
    newCode.generate
    return newCode
  end

  ## Generate a random code
  def generate
    raise Exception "Role must be set before generating a code" if self.role.nil?

    #allowedChars = "ABCDEFGHJKMNPQRTUVWXYZ234789"
    vowels = "AEIOU"
    consonants = "BCDFGHJKLMNPQRSTVWXYZ"
    numeric = "23456789"
    newCode = ""

    newCode << consonants[rand(consonants.size)]
    newCode << vowels[rand(vowels.size)]
    newCode << vowels[rand(vowels.size)]
    newCode << self.role.code_prefix

    2.times do
      newCode << vowels[rand(vowels.size)]
      newCode << consonants[rand(consonants.size)]
    end

    2.times do
      newCode << numeric[rand(numeric.size)]
    end

    self.code = newCode
  end
end
