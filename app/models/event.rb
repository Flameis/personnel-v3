class Event < ApplicationRecord
  self.inheritance_column = nil # don't treat type field as STI
  belongs_to :unit
  belongs_to :server
  belongs_to :reporter, foreign_key: "reporter_member_id", class_name: "User", optional: true
  has_many :attendance_records, -> { includes(user: :rank).order("ranks.order DESC", "members.last_name") }
  has_many :users, through: :attendance_records

  scope :by_user, ->(user) do
    unit_ids = user.active_assignment_unit_path_ids
    where(unit: unit_ids)
  end

  # TODO: Clean up data and convert field to enum
  validates :type, presence: true

  validates :datetime, presence: true
  validates_datetime :datetime
  validates :mandatory, inclusion: {in: [true, false]}
  validates :server, presence: true

  def expected_users
    unit.subtree_users.active
      .includes(:rank)
      .order("ranks.order DESC", "last_name")
  end

  def title
    if unit
      "#{unit.subtree_abbr} #{type}"
    else
      type
    end
  end

  # Alias for simple_calendar
  def start_time
    datetime
  end
end
