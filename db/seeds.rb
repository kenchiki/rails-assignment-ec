# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Tax.create(rate: 8, began_at: Time.current)
DeliveryFee.create(fee: 600, per: 5, began_at: Time.current)
CashOnDelivery.create(began_at: Time.current,
                      cash_on_delivery_fees_attributes: [
                        { began_price: 0, fee: 300 },
                        { began_price: 10_000, fee: 400 },
                        { began_price: 30_000, fee: 600 },
                        { began_price: 100_000, fee: 1000 }
                      ])

DeliveryTime.create(name: '8〜12時')
DeliveryTime.create(name: '12〜14時')
DeliveryTime.create(name: '14〜16時')
DeliveryTime.create(name: '16〜18時')
DeliveryTime.create(name: '18〜20時')
DeliveryTime.create(name: '20〜21時')
