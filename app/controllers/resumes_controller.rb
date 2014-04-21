class ResumesController < ApplicationController
  # GET /resumes
  # GET /resumes.json
  def index
    #binding.pry
    @resumes = Resume.first(5)

    @community_resumes = Resume.where(:category != "sample")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @resumes }
    end
  end

  # GET /resumes/1
  # GET /resumes/1.json
  def show
    @resume = Resume.find(params[:id])

    # We will worry about the pdf export later on. lets just get the flow and linkedin right right now
    #binding.pry
    #@resume[:content] = externals_to_absolute_path(@resume[:content])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resume }
      format.pdf do
        render pdf: "resume.pdf", template: "resumes/show.html.erb"
      end
    end
  end

  # GET /resumes/new
  # GET /resumes/new.json
  def new
    @resume = Resume.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @resume }
    end
  end

  # GET /resumes/1/edit
  def edit
    @resume = Resume.find(params[:id])
  end

  # POST /resumes
  # POST /resumes.json
  def create
    @resume = Resume.new(params[:resume])

    respond_to do |format|
      if @resume.save
        format.html { redirect_to @resume, notice: 'Resume was successfully created.' }
        format.json { render json: @resume, status: :created, location: @resume }
      else
        format.html { render action: "new" }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /resumes/1
  # PUT /resumes/1.json
  def update
    @resume = Resume.find(params[:id])

    @resume.content = params[:content][:page_content][:value]  
    @resume.category = ""
    @resume.save!

    render text: ""

=begin
    respond_to do |format|
      if @resume.update_attributes(params[:resume])
        format.html { redirect_to @resume, notice: 'Resume was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
=end
  end

  # DELETE /resumes/1
  # DELETE /resumes/1.json
  def destroy
    @resume = Resume.find(params[:id])
    @resume.destroy

    respond_to do |format|
      format.html { redirect_to resumes_url }
      format.json { head :no_content }
    end
  end

  def clone 
    template = Resume.find(params[:resume_id])

    new_record = template.dup
    new_record.save
    
    redirect_to "/editor/resumes/" + new_record.id.to_s
  end
end
