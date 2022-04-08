class Spree::Admin::PartsController < Spree::Admin::BaseController
  helper_method :product
  before_action :find_assembly_part, only: [:set_count, :remove]

  def index
    @parts = product.assemblies_parts.includes(:assembly, :part)
  end

  def remove
    @assembly_part.delete_all if assembly_part.present?
    render 'spree/admin/parts/update_parts_table'
  end

  def set_count
    @assembly_part.update_all(count: params[:count], part_id: params[:change_part_id]) if @assembly_part.present?
    render 'spree/admin/parts/update_parts_table'
  end

  def available
    if params[:q].blank?
      @available_products = []
    else
      query = "%#{params[:q]}%"
      @available_products = Spree::Product.search_can_be_part(query).distinct!
    end
    respond_to do |format|
      format.html {render :layout => false}
      format.js {render :layout => false}
    end
  end

  def create
    save_part(new_part_params)
  end

  private

  def save_part(part_params)
    form = Spree::AssignPartToBundleForm.new(product, part_params)
    if form.submit
      render 'spree/admin/parts/update_parts_table'
    else
      error_message = form.errors.full_messages.to_sentence
      render json: error_message.to_json, status: 422
    end
  end

  def product
    @product ||= Spree::Product.find_by(slug: params[:product_id])
  end

  def new_part_params
    params.require(:assemblies_part).permit(
      :count,
      :part_id,
      :assembly_id,
      :variant_selection_deferred
    )
  end

  def existing_part_params
    params.permit(:id, :count, :part_id)
  end

  def find_assembly_part
    @assembly_part = Spree::AssembliesPart.where(assembly_id: params[:id], part_id: params[:part_id])
  end
end
