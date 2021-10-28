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


Genre.find_or_create_by!(name: '中学受験')
Genre.find_or_create_by!(name: '高校受験')
Genre.find_or_create_by!(name: '大学受験')
Genre.find_or_create_by!(name: '資格試験')
Genre.find_or_create_by!(name: 'TOEIC')
Genre.find_or_create_by!(name: 'TOEFL')
Genre.find_or_create_by!(name: 'IELTS')
Genre.find_or_create_by!(name: 'その他')

Subject.find_or_create_by!(name: '国語')
Subject.find_or_create_by!(name: '算数')
Subject.find_or_create_by!(name: '理科')
Subject.find_or_create_by!(name: '社会')
Subject.find_or_create_by!(name: '現代文')
Subject.find_or_create_by!(name: '数学')
Subject.find_or_create_by!(name: '英語')
Subject.find_or_create_by!(name: '公民')
Subject.find_or_create_by!(name: '政治/経済')
Subject.find_or_create_by!(name: '地理')
Subject.find_or_create_by!(name: '科学')
Subject.find_or_create_by!(name: '物理')
Subject.find_or_create_by!(name: '化学')
Subject.find_or_create_by!(name: '情報')
Subject.find_or_create_by!(name: 'その他')