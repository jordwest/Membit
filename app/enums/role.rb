class Role < ClassyEnum::Base
  enum_classes :admin, :teacher, :participant, :tester

  def code_prefix
    'U'
  end
end

class RoleAdmin < Role
  def code_prefix
    'A'
  end
end

class RoleTeacher < Role
  def code_prefix
    'T'
  end
end

class RoleParticipant < Role
  def code_prefix
    'P'
  end
end

class RoleTester < Role
  def code_prefix
    'X'
  end
end

