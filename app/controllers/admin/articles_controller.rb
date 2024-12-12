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
      if @admin_article.valid?
        @admin_article.save
        format.html { redirect_to @admin_article, notice: 'Admin article was successfully created.' }
        format.json { render :show, status: :created, location: @admin_article }
      else
        format.html { render :new }
        format.json { render json: @admin_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/articles/1 or /admin/articles/1.json
  def update
    respond_to do |format|
      if @admin_article.update(admin_article_params)
        # ตรวจสอบและเปลี่ยนสถานะของ Content
        if @admin_article.content.draft?  # หากสถานะเป็น draft
          @admin_article.content.submit_for_review!  # เปลี่ยนเป็น in_review
        
        end
  
        # ส่งอีเมลแจ้งเตือน
        NotificationMailer.send_submission_notification(@admin_article).deliver_now
  
        # รีไดเรกต์ไปยังหน้าแสดงผล
        format.html { redirect_to @admin_article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_article }
      else
        # หากไม่สำเร็จให้แสดงหน้าแก้ไขพร้อมข้อผิดพลาด
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
      params.require(:admin_article).permit(
        :some_attribute, # อื่น ๆ ที่ไม่ใช่ content_attributes
        content_attributes: [:title, :description, :photo, :state]
      )
  end
end
