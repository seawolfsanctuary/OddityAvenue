class QuantityValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:quantity] << 'cannot be less than zero' unless record[:quantity] >= 0
  end
end