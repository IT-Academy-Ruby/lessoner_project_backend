json.user do
  json.id @user.id
  json.email @user.email
  json.avatarUrl @user.avatar_url
  json.description @user.description
  json.name @user.name
end
