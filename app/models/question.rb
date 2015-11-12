class Question < ActiveRecord::Base

  validates :text, presence: true
  validates :poll_id, presence: true

  has_many :answer_choices,
    foreign_key: :question_id,
    primary_key: :id,
    class_name: "AnswerChoice"

  belongs_to :poll,
    foreign_key: :poll_id,
    primary_key: :id,
    class_name: "Poll"

  has_many :responses,
    through: :answer_choices,
    source: :responses

  def results
    answers = answer_choices.includes(:responses)
    results = Hash.new

    answers.each do |answer|
      results[answer.text] = answer.responses.count
    end

    results
  end

  # def results
  #   answers = answer_choices
  #   results = Hash.new
  #
  #   answers.each do |answer|
  #     results[answer.text] = answer.responses.count
  #   end
  #
  #   results
  # end

end
