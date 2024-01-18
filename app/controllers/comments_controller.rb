class CommentsController < ApplicationController
    before_action :set_design
    before_action :set_comment, only: [:edit, :update, :destroy]
    before_action :authenticate_user! 
  
    def index
        @comments = Comment.all
    end 

    def create
      @comment = @design.comments.build(comment_params)
      @comment.user = current_user
  
      if @comment.save
        redirect_to @design, notice: 'Comment was successfully created.'
      else
        flash[:alert] = 'Comment could not be saved.'
        render 'designs/show'
      end
    end
  
    def edit
      authorize_comment_owner!
    end
  
    def update
      authorize_comment_owner!
  
      if @comment.update(comment_params)
        redirect_to @comment.design, notice: 'Comment was successfully updated.'
      else
        flash[:alert] = 'Comment could not be updated.'
        render 'edit'
      end
    end
  
    def destroy
      authorize_comment_owner!
      @comment.destroy
      redirect_to @comment.design, notice: 'Comment was successfully destroyed.'
    end
  
    private
  
    def set_design
      @design = Design.find(params[:design_id])
    end
  
    def set_comment
      @comment = Comment.find(params[:id])
    end
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  
    def authorize_comment_owner!
      unless current_user == @comment.user
        flash[:alert] = 'You are not authorized to perform this action.'
        redirect_to @comment.design
      end
    end
  end
  