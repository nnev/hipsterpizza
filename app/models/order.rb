# encoding: utf-8

class Order < ActiveRecord::Base
  belongs_to :basket, touch: true

  validates :uuid, presence: true, uniqueness: true
  validates :json, presence: true, json: true
  validates :nick, presence: true
  validates :basket_id, presence: true

  scope :paid, -> { where(paid: true) }
  scope :unpaid, -> { where(paid: false) }
  scope :sorted, -> { order('lower(nick) asc') }


  before_validation(on: :create) do
    create_uuid
  end

  def json_parsed
    ActiveSupport::JSON.decode(json)
  end

  def sum
    json_parsed.map { |i| i['price'] }.sum
  end

  def tip_percent
    if defined?(CONFIG['tip_percent']) && CONFIG['tip_percent'] > 0
	  return CONFIG['tip_percent']
	else
	  return 0
	end
  end

  def sum_with_tip
    # round to nearest 10 cents
    (sum * tip_percent/100.0 + sum).round(1)
  end

  def nick_id
    n = UnicodeUtils.canonical_decomposition(nick)
    n = n.gsub(/[^a-z0-9]/i, "").upcase[0..2]
    n[1] ||= '~'
    n[2] ||= '~'
    n
  end

  # returns the date the order was actually submitted, i.e. the basket
  # submit time.
  def date
    basket.submitted.strftime('%Y-%m-%d') rescue 'never'
  end

  private
  def create_uuid
    raise 'Order has already an UUID'  if self.uuid
    other = Order.pluck(:uuid)
    2.times do
      self.uuid = SecureRandom.uuid
      break unless other.include?(self.uuid)
    end
  end
end
