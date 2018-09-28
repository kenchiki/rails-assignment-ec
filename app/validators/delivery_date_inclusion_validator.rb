# frozen_string_literal: true

class DeliveryDateInclusionValidator < ActiveModel::Validator
  delegate :schedule_date_include?, to: :delivery_date_schedule

  def validate(record)
    return if schedule_date_include?(record.send(options[:field]))
    record.errors.add(options[:field], :not_included)
  end

  def delivery_date_schedule
    DeliveryDateSchedule.new
  end
end
