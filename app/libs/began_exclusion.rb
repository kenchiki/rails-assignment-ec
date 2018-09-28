# frozen_string_literal: true

class BeganExclusion
  def before_destroy(record)
    throw(:abort) if record.began_at.past?
  end
end
