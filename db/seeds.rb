# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if User.none?
  User.create(user_name: 'ABC', email: 'admin@aaa.com', password: 'abc123')
end

ApiManage.create_with(manage: 0).find_or_create_by(api_name: 'download')
ApiManage.create_with(manage: 0).find_or_create_by(api_name: 'resolution')
