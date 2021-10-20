# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(email: 'reality_0518@yahoo.co.jp', password: 'sakusaku') if Admin.find_by(email: 'reality_0518@yahoo.co.jp').nil?
User.create!(email: 'test@test', name: 'test', nick_name: '最強マン', password: 'testtest') if User.find_by(email: 'test@test').nil?
User.create!(email: 'qqq@qqq', name: 'test1', nick_name: '天才マン', password: 'qqqqqq') if User.find_by(email: 'qqq@qqq').nil?
User.create!(email: 'aaa@aaa', name: 'test2', nick_name: '完全マン', password: 'aaaaaa') if User.find_by(email: 'aaa@aaa').nil?


Genre.find_or_create_by!(name: '大学受験')
Subject.find_or_create_by!(name: '英語')