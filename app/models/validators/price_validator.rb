class PriceValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:price] << 'cannot be less than zero' unless record[:price] >= 0.00
  end
end