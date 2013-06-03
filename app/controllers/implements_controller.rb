class ImplementsController < ApplicationController

  before_filter :authenticate_user
  respond_to :json, :html

  def index
    @implements = Implement.all
  end
  
  def new
    @implement = Implement.new
  end
  
  def create
    @implement = create_or_update(params)
    if @implement.errors.empty?
      respond_with :html => @implement
    else
      @entity = @implement
      respond_with do |format|
        format.html { render :html => @entity, :template => "shared/entity_errors" }
      end
    end
  end

  def edit
    @implement = Implement.find_by_permalink(params[:id])
  end
  
  def update
    @implement = create_or_update(params)
    if @implement.errors.empty?
      respond_with :html => @implement
    else
      @entity = @implement
      respond_with do |format|
        format.html { render :html => @entity, :template => "shared/entity_errors" }
      end
    end
  end
  
  def show
    @implement = Implement.find_by_permalink(params[:id])
  end

  def is_name_unique
    implement_id = params[:implement_id]
    implement = Implement.first(:conditions => { :permalink => implement_id.to_identifier })
    respond_with do |format|
      format.json { render :json => implement.nil? }
    end
  end

  private
  def create_or_update(params)
    Implement.transaction do
      implement = params[:id] ? Implement.find_by_permalink(params[:id]) : Implement.new()
      implement.update_attributes(params[:implement])
      implement.creator ||= current_user
      implement.save
      implement
    end
  end

end
