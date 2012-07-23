class HelpTopic
  def initialize(title)
    @questions = Array.new
    @topic_name = title
  end

  def add_question(question, answer)
    new_question = Hash.new
    new_question["question"] = question
    new_question["answer"] = answer
    self.questions << new_question
  end

  def questions
    @questions
  end

  def title
    @title
  end
end