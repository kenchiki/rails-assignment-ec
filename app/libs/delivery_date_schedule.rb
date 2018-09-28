# frozen_string_literal: true

class DeliveryDateSchedule
  DATE_MIN = 3
  DATE_MAX = 14
  LOOP_MAX = 100

  def calc_schedule_dates
    current_date = Time.current.to_date
    delivery_dates = []
    date_count = 0
    LOOP_MAX.times do
      break if delivery_dates.size >= (DATE_MAX - DATE_MIN)
      delivery_dates << current_date if date_addable?(current_date, date_count)
      current_date = current_date.tomorrow
      date_count += 1 if date_count < DATE_MIN
    end
    delivery_dates
  end

  def schedule_dates
    @schedule_dates ||= calc_schedule_dates
  end

  def schedule_date_include?(schedule_date)
    schedule_dates.include?(schedule_date)
  end

  private

  def date_addable?(current_date, date_count)
    return false if current_date.sunday? || current_date.saturday? || date_count < DATE_MIN
    true
  end
end
