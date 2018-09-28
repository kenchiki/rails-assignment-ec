# frozen_string_literal: true

class EmailSetting
  def self.from
    ENV.fetch('EMAIL_FROM', 'admin@example.com')
  end
end
