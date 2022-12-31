json.records do
  json.array! @users do |user|
    json.extract! user, :id, :name, :description, :email, :avatar_url, :phone, :gender, :birthday, :created_at
  end
end

json.pagy_metadata do
  json.page @pagy.page
  json.per_page @pagy.items
  json.count_pages @pagy.pages
end
