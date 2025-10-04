class BmrCalculation < ActiveRecord::Base
  paginates_per 10
  max_paginates_per 50

  belongs_to :patient

  validates :formula, :result, presence: true
  validates :formula, inclusion: { in: %w[mifflin harris] }
  validates :result, numericality: { 
    greater_than: 0,
    less_than: 10000
  }

  scope :recent, -> { order(created_at: :desc) }
end
