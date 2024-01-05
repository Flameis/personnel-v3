class AttendanceRecord < ApplicationRecord
  self.table_name = "attendance"
  belongs_to :user, foreign_key: "member_id"
  belongs_to :event

  scope :without_cancelled_loas, -> { where.not(attended: nil).or(where(excused: true)) }
  scope :awol, -> {
    includes(:event)
      .where(attended: false, excused: false,
        event: {mandatory: true, starts_at: ..24.hours.ago})
  }

  validates :attended, inclusion: {in: [true, false]}, allow_nil: true
  validates :excused, inclusion: {in: [true, false]}

  # :attended | (:extended_loa | :excused) | (:awol | :absent)
  def status
    if attended
      :attended
    elsif excused
      if excused_by_extended_loa?
        :extended_loa
      else
        :excused
      end
    elsif event.mandatory
      :awol
    else
      :absent
    end
  end

  def awol?
    !attended && !excused
  end

  def excused_by_extended_loa?
    user.on_extended_loa?(event.datetime)
  end
end
