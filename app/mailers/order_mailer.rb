class OrderMailer < ApplicationMailer
  def self.user_thanks(presenter)
    with(order: presenter[:order]).user_thanks.deliver_later
  end

  def self.notify_admin(presenter)
    with(order: presenter[:order]).notify_admin.deliver_later
  end

  def user_thanks
    @order = params[:order]
    mail(to: @order.user_email, subject: '【さくらマーケット】ご注文ありがとうございます')
  end

  def notify_admin
    @order = params[:order]
    mail(to: Administrator.emails, subject: "【さくらマーケット】注文がありました(ID:#{@order.id})")
  end
end
