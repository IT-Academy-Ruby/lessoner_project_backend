class Category < ApplicationRecord

    enum :status, [:active, :archived]

    validates :name, presence: true
    validates :description, presence: true
    
end
