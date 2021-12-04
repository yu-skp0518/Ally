# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(email: ENV['ADMIN_EMAIL'], password: ENV['ADMIN_PASSWORD']) if Admin.find_by(email: ENV['ADMIN_EMAIL']).nil?
User.create!(email: 'test@test', name: 'test', nick_name: '田中太郎', password: 'testtest') if User.find_by(email: 'test@test').nil?
User.create!(email: 'qqq@qqq', name: 'test1', nick_name: '山田花子', password: 'qqqqqq') if User.find_by(email: 'qqq@qqq').nil?
User.create!(email: 'aaa@aaa', name: 'test2', nick_name: '鈴木一郎', password: 'aaaaaa') if User.find_by(email: 'aaa@aaa').nil?


[
  '中学受験',
  '高校受験',
  '大学受験',
  '資格試験',
  'TOEIC',
  'TOEFL',
  'IELTS',
  'その他'
].each do |name|
  Genre.find_or_create_by!(name: name)
end

[
'国語',
'算数',
'理科',
'社会',
'現代文',
'数学',
'英語',
'公民',
'政治/経済',
'地理',
'科学',
'物理',
'化学',
'情報',
'その他'
].each do |name|
  Subject.find_or_create_by!(name: name)
end