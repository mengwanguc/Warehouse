class ApisController < ApplicationController
  def get_inventory
    if params["api_key"].present?
      @user = User.find_by(api_key: params["api_key"])
      if @user.blank?
        render :json => { :errors => "Invalid api key!" }, :status => 422
      else
        render json:@user.invents
      end
    else
      render :json => { :errors => "Missing api key!" }, :status => 422
    end
  end


  # get inventory data of a particular sku
  def get_sku_inventory
    if params["api_key"].present?
      @user = User.find_by(api_key: params["api_key"])
      if @user.blank?
        render :json => { :errors => "Invalid api key!" }, :status => 422
      else
        render json:@user.invents.where(sku: params["sku"])
      end
    else
      render :json => { :errors => "Missing api key!" }, :status => 422
    end
  end


  # add stock
  def add_inventory
    unless params["api_key"].present?
      render :json => { :errors => "Missing api key!" }, :status => 422
    else
      unless params["sku"].present?
        render :json => { :errors => "Missing sku!" }, :status => 422
      else
        unless params["qty"].present?
          render :json => { :errors => "Missing qty!" }, :status => 422
        else
          unless params["qty"].to_i > 0
            render :json => { :errors => "qty must be a positive integer!" }, :status => 400
          else
            @user = User.find_by(api_key: params["api_key"])
            if @user.blank?
              render :json => { :errors => "Invalid api key!" }, :status => 422
            else
              @inventory = @user.invents.find_by(sku: params["sku"], status: "In Stock")
              if @inventory.blank?
                @inventory = Invent.new
                @inventory.user_id = @user.id
                @inventory.sku = params["sku"]
                @inventory.status = "In Stock"
                @inventory.qty = params['qty'].to_i
              else
                @inventory.qty += params['qty'].to_i
              end
              if @inventory.qty > 2000
                render :json => { :errors => "You can store at most 2000 items for a particular SKU!" }, :status => 400
              else
                if @inventory.save
                  render json: @inventory
                else
                  render :json => { :errors => @inventory.errors.full_messages }, :status => 400
                end
              end
            end
          end
        end
      end
    end
  end



  # place order for shipment
  def place_order
    unless params["api_key"].present?
      render :json => { :errors => "Missing api key!" }, :status => 422
    else
      unless params["sku"].present?
        render :json => { :errors => "Missing sku!" }, :status => 422
      else
        unless params["qty"].present?
          render :json => { :errors => "Missing qty!" }, :status => 422
        else
          unless params["qty"].to_i > 0
            render :json => { :errors => "qty must be a positive integer!" }, :status => 400
          else
            unless params["address"].present?
              render :json => { :errors => "Missing address!" }, :status => 422
            else
              @user = User.find_by(api_key: params["api_key"])
              if @user.blank?
                render :json => { :errors => "Invalid api key!" }, :status => 422
              else
                @stock = @user.invents.find_by(sku: params["sku"], status: "In Stock")
                if @stock.blank? || @stock.qty < params["qty"].to_i
                  render :json => { :errors => "Only #{if @stock.blank? then 0 else @stock.qty end} items in stock! Please order less!" }, :status => 400
                else
                  @stock.qty -= params["qty"].to_i
                  @shipment = @user.invents.find_by(sku: params["sku"], status: "Preparing for Shipment")
                  if @shipment.blank?
                    @shipment = Invent.new
                    @shipment.user_id = @user.id
                    @shipment.sku = params["sku"]
                    @shipment.status = "Preparing for Shipment"
                    @shipment.qty = params['qty'].to_i
                  else
                    @shipment.qty += params['qty'].to_i
                  end
                  @stock.save
                  @shipment.save
                  res = {'result': 'Order made successfully!', 'stock': @stock, 'pre_ship': @shipment}
                  render json: res
                end
              end
            end
          end
        end
      end
    end
  end
end
