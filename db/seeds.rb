# frozen_string_literal: true

downloaded_image1 = URI.parse('https://res.cloudinary.com/dol7sxbjz/image/upload/v1661751534/SkBMx74XMoefUFLhCZgmvr6a.jpg').open
downloaded_image2 = URI.parse('https://res.cloudinary.com/dol7sxbjz/image/upload/v1661752651/VEGTVCfopnFPvNAA9XNnrdJ4.jpg').open
downloaded_image3 = URI.parse('https://res.cloudinary.com/dol7sxbjz/image/upload/v1661151666/cld-sample.jpg').open

user1 = User.new(name: 'Noor',
                 email: 'noor.ulain@devsinc.com',
                 password: '123456',
                 password_confirmation: '123456',
                 usertype: 'Admin')

user1.avatar.attach(io: downloaded_image1, filename: 'Admin.jpg')
user1.save!
user2 = User.new(name: 'Amna',
                 email: 'amnah.siddiqua@devsinc.com',
                 password: '123456',
                 password_confirmation: '123456',
                 usertype: 'Buyer')

user2.avatar.attach(io: downloaded_image2, filename: 'Buyer.jpg')
user2.save!

user3 = User.new(name: 'Umair',
                 email: 'umair.qaisar@devsinc.com',
                 password: '123456',
                 password_confirmation: '123456',
                 usertype: 'Buyer')
user3.avatar.attach(io: downloaded_image3, filename: 'Buyer.jpg')
user3.save!
