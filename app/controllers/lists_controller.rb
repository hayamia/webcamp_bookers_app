class ListsController < ApplicationController

  def index
    @list = List.new
    @lists = List.all
  end

  def show
    @list = List.find(params[:id])
  end

  def new
  end
  
  def create
    @list = List.new(list_params)
    if @list.save
      redirect_to list_path(@list), flash: { notice: 'Book was successfully created.'}
    else
      @lists = List.all
      render :index
    end
  end

  def edit
    @list = List.find(params[:id])
  end
  
  def update
    @list = List.find(params[:id])
    if @list.update(list_params)
      redirect_to list_path(@list), flash: { notice: 'Book was successfully changed.'}
    else
      render :edit
    end
  end
  
  def destroy
    list = List.find(params[:id])
    list.destroy
    redirect_to lists_path
  end
  
  private
  def list_params
    params.require(:list).permit(:title, :body)
  end
end
