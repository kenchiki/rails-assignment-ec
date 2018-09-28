if Rails.env.test?
  Capybara.add_selector(:test) do
    css {|type| "[data-test='#{type}']"}
  end
end
