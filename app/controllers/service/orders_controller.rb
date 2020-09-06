module Service
  class OrdersController < ServiceController
    skip_before_action :require_user, only: [:plans]
    def create
      plan_id = params[:plan_id].to_i

      plan = Plan.where(plan_type: plan_id).first
      raise ErrorModel.new(ErrorModel::ARGUMENT_ERROR, "잘못된 접급입니다.") if plan.blank?

      order = Order.create_order(@current_user, plan)
      render json: {id: order.id}
    end

    def show
      @id = params[:id]
      @order = Order.where(id: @id).first
      @plan = @order.plan
    end

    def plans
    end

    def complete
      id = params[:id]
      imp_uid = params[:imp_uid]
      Order.complete_order(id, imp_uid)

      render json: {id: id}
    end

    def done
    end
  end
end