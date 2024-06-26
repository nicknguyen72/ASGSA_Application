# frozen_string_literal: true

class Email < ApplicationRecord
  validates :president, presence: true
  validates :vice_president, presence: true
  validates :secretary, presence: true
  validates :treasurer, presence: true
  validates :public_relations, presence: true
  validates :members_at_large, presence: true
  validates :org_email, presence: true
  validates :start_year, presence: true
  validates :end_year, presence: true
end
