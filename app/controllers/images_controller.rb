class ImagesController < ApplicationController
  before_action :set_image, only: %i[show edit update destroy]

  def index
    @tag = params[:tag]
    @images = Image.order created_at: :desc
    @images = @images.tagged_with(@tag) if @tag
  end

  # GET /images/1
  def show; end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit; end

  # POST /images
  def create
    @image = Image.new(creation_params)

    if @image.save
      redirect_to @image, notice: 'Image was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /images/1
  def update
    if @image.update(update_params)
      redirect_to @image, notice: 'Image was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /images/1
  def destroy
    @image.destroy!
    redirect_to root_url, notice: 'Image was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @image = Image.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def creation_params
    params.require(:image).permit(:url, :tag_list)
  end

  # Only allow a trusted parameter "white list" through.
  def update_params
    params.require(:image).permit(:tag_list)
  end
end
