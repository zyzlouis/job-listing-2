class JobsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
    before_action :validate_search_key, only: [:search]

    def index
      @jobs = case params[:order]
              when 'by_lower_bound'
                Job.published.order('wage_lower_bound DESC')
              when 'by_upper_bound'
                Job.published.order('wage_upper_bound DESC')
              else
                Job.published.recent
              end
    end

#  def index
#    @search = Job.ransack(params[:q]）
#    @jobs = @search.result.where(is_hidden: false)
#  end



  def show
    @job = Job.find(params[:id])
    if @job.is_hidden
      flash[:warning] = "This Job already archived"
      redirect_to root_path
    end
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)

    if @job.save
      redirect_to jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to jobs_path, notice: "Update job info success"
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])

    @job.destroy

    redirect_to jobs_path, alert: "Deleted job info success"
  end

  def search
    if @query_string.present?
      @jobs = Job.published.ransack(@search_criteria).result(:distinct => true)
  #    @jobs = search_result
    end
  end

  protected

  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "")
    if params[:q].present?
      @search_criteria = {
        title_cont: @query_string
      }
    end
  end


  def search_criteria(query_string)
    { :title_cont => query_string }
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_upper_bound, :wage_lower_bound, :contact_email)
  end

end
