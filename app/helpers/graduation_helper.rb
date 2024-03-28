module GraduationHelper
  def assignment_hint(enlistment)
    timezone = Enlistment.timezones[enlistment.timezone]
    hint = "Preferred drill time: #{timezone}"

    if enlistment.recruiter_user.present?
      recruiter_units = enlistment.recruiter_user.active_assignments
        .filter { |assignment| assignment.unit.combat? }
        .map { |assignment| assignment.unit.abbr }
        .uniq
        .join(", ")

      hint += " - Recruiter: #{enlistment.recruiter_user} (#{recruiter_units})"
    end

    hint
  end
end
