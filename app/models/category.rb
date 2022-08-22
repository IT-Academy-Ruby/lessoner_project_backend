class Category < ApplicationRecord
    include Visible

    validates :name, presence: true
    validates :description, presence: true
end
