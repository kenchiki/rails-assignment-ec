# frozen_string_literal: true

namespace :sample do
  desc 'Create demo'
  # デモ用の商品登録、管理者、ユーザを作成
  task create_demo: :environment do
    # サンプル商品を１００個作る
    product_number = 100
    product_number.times do |no|
      Product.create(
        name: "product#{no}",
        product_prices_attributes: [
          price: [*(1..99)].sample * 100
        ],
        product_publishes_attributes: [
          published: true
        ]
      )
    end

    # 管理デモユーザーを作成
    demo_admin_user_email = ENV.fetch('DEMO_ADMIN_USER_EMAIL', 'admin@example.com')
    demo_admin_user_password = ENV.fetch('DEMO_ADMIN_USER_PASSWORD', 'test_password')
    demo_admin_user = User.new(email: demo_admin_user_email,
                               password: demo_admin_user_password)
    demo_admin_user.skip_confirmation!
    demo_admin_user.save!

    ENV.store('USER_ID', demo_admin_user.id.to_s)
    Rake::Task['administrator:become'].invoke

    # お買い物デモユーザーを作成
    demo_user_email = ENV.fetch('DEMO_USER_EMAIL', 'user@example.com')
    demo_user_password = ENV.fetch('DEMO_USER_PASSWORD', 'test_password')
    demo_user = User.new(email: demo_user_email,
                         password: demo_user_password)
    demo_user.skip_confirmation!
    demo_user.save
  end
end
