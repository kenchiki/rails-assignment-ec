# 概要
ECサイトの開発課題

# 消費税、送料の初期登録
- `rake db:seed`

# 管理者設定手順
- `rails administrator:become USER_ID=1`

# 本番環境で設定する環境変数
```ruby
# herokuでは○○.herokuapp.comを設定
ACTION_MAILER_DOMAIN

# herokuでは○○.herokuapp.comを設定
ACTION_MAILER_HOST

# herokuでは設定不要（未設定の場合、ENV['ACTION_MAILER_PORT']はnilになる）
ACTION_MAILER_PORT

# herokuのSENDGRIDプラグインで自動で設定される
SENDGRID_USERNAME

# herokuのSENDGRIDプラグインで自動で設定される
SENDGRID_PASSWORD

# awsの設定
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
AWS_HOST
AWS_ENDPOINT
AWS_BUCKET

# メールアドレス送信時のFROM
EMAIL_FROM
```
