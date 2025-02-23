class Subscription < ApplicationRecord
  belongs_to :user
  #belongs_to :user, counter_cache: true #counter_cache not working here for some reason
  belongs_to :course, counter_cache: true

  scope :pending_review, -> { where(rating: [0, nil, ""], comment: [nil, ""]) }
  scope :rated, -> { where.not(comment: [nil, ""]) }

  validates :user, :course, presence: true

  validates_presence_of :rating, if: :comment?
  validates_presence_of :comment, if: :rating?
  # User can't be subscribed to the same course twice
  validates_uniqueness_of :user_id, scope: :course_id
  # User can't be subscribed to the same course twice
  validates_uniqueness_of :course_id, scope: :user_id

  # User can't create a subscription if course.user == current_user.id
  validate :cant_subscribe_to_own_course
  protected
  def cant_subscribe_to_own_course
    if self.new_record?
      if user_id == course.user_id
        errors.add(:base, "You can not subscribe to your own course")
      end
    end
  end

  after_destroy do
    course.update_rating
  end

  after_save do
    unless rating.nil? || rating.zero?
      course.update_rating
    end
  end
end
