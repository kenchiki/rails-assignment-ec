# frozen_string_literal: true

class TaxPresenter
  attr_writer :tax
  attr_reader :params

  def initialize(args)
    @params = args[:params]
    set_path_models
  end

  def tax
    @tax.presence || Tax.new
  end

  def current_tax
    Tax.began_last
  end

  def taxes
    Tax.id_desc
  end

  def set_path_models
    @tax = Tax.find(params[:id]) if params[:id]
  end
end
