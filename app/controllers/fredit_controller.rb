require 'git'
require 'fileutils'

class FreditController < ::ApplicationController
  skip_before_filter :verify_authenticity_token

  layout 'fredit'

  before_filter :load_git

  CSS_DIR = Rails.root + 'public/stylesheets/**/*.css'
  JS_DIR = Rails.root + 'public/javascripts/**/*.js'

  def show
    @path ||= secure_path(params[:file] || Fredit.editables[:views].first)
    load_git_log
    @source = File.read(Rails.root + @path)
  end

  def update
    @path = secure_path params[:file_path]

    session[:commit_author] = (params[:commit_author] || '')
    # cleanup any shell injection attempt characters
    author = session[:commit_author].gsub(/[^\w@<>. ]/, '') 

    if session[:commit_author].blank?
      flash.now[:notice] = "Edited By must not be blank"
      @source = params[:source]
      load_git_log
      render :action => 'show'
      return
    end

    if params[:commit] =~ /delete/i
      res = Fredit::StandardBackend.delete(@path, author)
      flash[:notice] = "#{path} deleted"
      @path = nil
    else
      content = params[:source].gsub(/\r\n/, "\n")
      res = Fredit::StandardBackend.update(@path, content, params[:edit_message], author)
      flash[:notice] = "#@path updated"
    end
    if res == false
      flash[:notice] = "Something went wrong with git. Make sure you changed something and filled in required fields."
    end
    redirect_to fredit_path(:file => @path)
  end
  
  def create
    @path = secure_path params[:new_file]
    Fredit::StandardBackend.create(@path)
    flash[:notice] = "Created new file: #@path"
    redirect_to fredit_path(:file => @path)
  end

  def upload
    @path = secure_path params[:file_path]
    upload = params[:upload_file]
    if !upload.respond_to?(:original_filename)
      flash[:notice] = "You need to choose a file to upload"
      redirect_to fredit_path(file: @path)
      return
    end
    author = session[:commit_author] = (params[:commit_author] || '').gsub(/[^\w@<>. ]/, '') 
    if author.blank?
      flash[:notice] = "Uploaded By must not be blank"
      redirect_to :back
      return
    end
    res = Fredit::StandardBackend.upload(upload, author)

    redirect_to fredit_path(@path)
  end

  def revision
    @path = secure_path params[:file]
    load_git_log
    @sha = params[:sha].gsub(/[^0-9a-z]/, '') # shell injection protection
    @git_object = @git.object(@sha)
    @diff = `git show #{@sha}`
  end

private

  def load_git
    @git = Git.init Rails.root.to_s
  end

  def load_git_log
    @git_log = @git.log(20).object(@path).to_a
  rescue Git::GitExecuteError
    @git_log = []
    flash[:notice] = "You need to initialize a git repository or add this file to the path"
  end

  def secure_path(path)
    path2 = File.expand_path(path.to_s)
    if path2.index(Rails.root.to_s) != 0
      raise "Unauthorized path: #{path2} (Raw: #{path})"
    end
    path
  end

end
