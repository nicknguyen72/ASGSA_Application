class Event < ApplicationRecord
    validates :name, presence: true
    validates :location, presence: true
    validates :start_time, presence: true
    validates :end_time, presence: true
    validates :date, presence: true
    validates :description, presence: false
    validates :capacity, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_blank: true
    validates :points, numericality: {only_integer: true, greater_than_or_equal_to: 0}

    has_many :attendees
end
