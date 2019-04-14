class CategoryFormula < ApplicationRecord
  has_many :category_formula_histories
  belongs_to :category, primary_key: :category_number, foreign_key: :category_number

  before_save :increase_version
  after_save :snapshot!

  def increase_version
    self.version += 1
  end

  def snapshot!
    params = CategoryFormulaHistory::WHITE_COLUMN.map { |column| [column, self.send(column)] }
    category_formula_histories.create!(Hash[params])
  end

  def calculate(sample)
    return 0 unless sample.to_s =~ /^[0-9A-F]{8}$/i
    begin
      hex_string = sample.gsub(/([0-9A-F]{2})/i,':\1').split(':').reverse.join
      x = hex_string.to_i(16)
      eval(self.formula).to_i
    rescue
      0
    end
  end

end
