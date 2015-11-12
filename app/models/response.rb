class Response < ActiveRecord::Base

  validates :user_id, :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question,
    :respondent_is_not_poll_creator

  belongs_to :answer_choice,
    foreign_key: :answer_choice_id,
    primary_key: :id,
    class_name: "AnswerChoice"

  belongs_to :respondent,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: "User"

  has_one :question,
    through: :answer_choice,
    source: :question

  def sibling_responses
    question
      .responses
      .where(":id IS NULL OR responses.id != :id", id: self.id)
  end

  def author_of_poll
    answer_choice
      .question
      .poll
      .author_id
  end

  private
  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(user_id: self.user_id)
      errors[:user_id] << "User has already responded to this question"
    end
  end

  def respondent_is_not_poll_creator
    if author_of_poll == user_id
      errors[:user_id] << "Author can't answer own question"
    end
  end

end
