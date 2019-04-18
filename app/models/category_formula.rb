class CategoryFormula < ApplicationRecord
  has_many :category_formula_histories
  belongs_to :category, primary_key: :category_number, foreign_key: :category_number

  before_save :increase_version
  after_save :snapshot!

  def self.last_updated_at
    all.map(&:updated_at).max
  end

  def increase_version
    self.version += 1
  end

  def snapshot!
    params = CategoryFormulaHistory::WHITE_COLUMN.map { |column| [column, self.send(column)] }
    category_formula_histories.create!(Hash[params])
  end

  def calculate(sample)
    return 0 unless sample.to_s =~ /^[0-9A-F]{8}$/i
    result_min = 0
    result_max = self.top_limit || 9999
    begin
      hex_string = sample.scan(/[0-9A-F]{2}/i).reverse.join
      x = hex_string.to_i(16)
      result = eval(self.formula).round
      result = result_min if result < result_min
      result = result_max if result > result_max
      result
    rescue
      0
    end
  end

end
