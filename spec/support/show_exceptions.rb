module ShowExceptions
  shared_context :show_exceptions do
    around(:each) do |example|
      show_detailed_exceptions = Rails.application.env_config['action_dispatch.show_detailed_exceptions']
      show_exceptions = Rails.application.env_config['action_dispatch.show_exceptions']

      Rails.application.env_config['action_dispatch.show_detailed_exceptions'] = false
      Rails.application.env_config['action_dispatch.show_exceptions'] = true

      example.run

      Rails.application.env_config['action_dispatch.show_detailed_exceptions'] = show_detailed_exceptions
      Rails.application.env_config['action_dispatch.show_exceptions'] = show_exceptions
    end
  end
end
