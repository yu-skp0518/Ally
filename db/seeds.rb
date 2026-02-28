# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# 管理ユーザー（環境変数で指定、既にいればスキップ）
if ENV['ADMIN_EMAIL'].present? && ENV['ADMIN_PASSWORD'].present? && Admin.find_by(email: ENV['ADMIN_EMAIL']).nil?
  Admin.create!(email: ENV['ADMIN_EMAIL'], password: ENV['ADMIN_PASSWORD'])
end

# テスト用ユーザー（既に同じ email がいればスキップ。name 重複時もスキップ）
[
  { email: 'test@test', name: 'test', nick_name: '田中太郎', password: 'testtest' },
  { email: 'qqq@qqq', name: 'test1', nick_name: '山田花子', password: 'qqqqqq' },
  { email: 'aaa@aaa', name: 'test2', nick_name: '鈴木一郎', password: 'aaaaaa' }
].each do |attrs|
  next if User.exists?(email: attrs[:email])
  User.create!(attrs)
rescue ActiveRecord::RecordInvalid
  # 同じ name のユーザーが既にいるときはスキップ
end

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