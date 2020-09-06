class Order < ApplicationRecord

  belongs_to :user
  belongs_to :plan

  enum status: {ready: 0, paid: 1, canceled: 2, refunded: 3, partial_refunded: 4, failed: 6}

  class << self
    def create_order(user, plan)
      order = Order.new(user: user, plan: plan, status: :ready, amount: plan.price)
      order.merchant_uid = "#{user.id}_#{Time.now.to_i}"
      order.save
      order
    end

    def complete_order(id, imp_uid)
      order = Order.find(id)
      order.transaction do
        order.status = :paid
        order.imp_uid = imp_uid
        order.save
      end
    end
  end
end
