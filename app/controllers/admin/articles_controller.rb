# app/controllers/admin/articles_controller.rb
class Admin::ArticlesController < ApplicationController
  before_action :set_admin_article, only: %i[show edit update destroy]

  # GET /admin/articles or /admin/articles.json
  def index
    @admin_articles = Admin::Article.all
  end

  # GET /admin/articles/1 or /admin/articles/1.json
  def show
  end

  # GET /admin/articles/new
  def new
    @admin_article = Admin::Article.new
    @admin_article.build_content  # เพิ่มบรรทัดนี้เพื่อสร้าง Content ให้กับ Admin::Article
  end

  # GET /admin/articles/1/edit
  def edit
  end

  # POST /admin/articles or /admin/articles.json
  def create
    @admin_article = Admin::Article.new(admin_article_params)

    respond_to do |format|
      if @admin_article.save
        # หากสถานะของ Content ยังเป็น draft, เปลี่ยนสถานะเป็น in_review
        @admin_article.content.submit_for_review! if @admin_article.content.draft?
        NotificationMailer.send_submission_notification(@admin_article).deliver_now
        format.html { redirect_to @admin_article, notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @admin_article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/articles/1 or /admin/articles/1.json
  def update
    respond_to do |format|
      if @admin_article.update(admin_article_params)
        # หากสถานะของ Content ถูกเปลี่ยนแปลง, เปลี่ยนสถานะให้เป็นตามนั้น
        if @admin_article.content.draft?
          @admin_article.content.submit_for_review!
        elsif @admin_article.content.in_review?
          @admin_article.content.approve!  # หรือ @admin_article.content.reject! ขึ้นอยู่กับสถานการณ์
        end
        NotificationMailer.send_submission_notification(@admin_article).deliver_now
        format.html { redirect_to @admin_article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_article.errors, status: :unprocessable_entity }
      end
    end
  end
 

  # DELETE /admin/articles/1 or /admin/articles/1.json
  def destroy
    @admin_article.destroy!

    respond_to do |format|
      format.html { redirect_to admin_articles_path, status: :see_other, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_admin_article
    @admin_article = Admin::Article.find(params[:id])
  end

  def admin_article_params
    params.require(:admin_article).permit(:title, :description, :photo, content_attributes: [:title, :description, :photo, :state])
  end
end
