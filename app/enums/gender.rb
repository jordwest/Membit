class Gender < ClassyEnum::Base
  enum_classes :male, :female
end

class GenderMale < Gender

end

class GenderFemale < Gender

end

