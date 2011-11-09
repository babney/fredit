module Fredit
  class StandardBackend < Fredit::Backend
    def self.create(path)
      FileUtils::mkdir_p File.dirname(path)
      File.open(path, 'w') {|f| f.write("REPLACE WITH CONTENT")}
    end
    def self.upload(upload, author)
      filename = upload.original_filename
      upload_dir = secure_path( params[:target_dir] || 'public/images' )
      FileUtils::mkdir_p upload_dir
      upload_path = File.join(upload_dir, filename)
      File.open(upload_path, 'wb') {|f| f.write(upload.read)}
      flash[:notice] = "File successfully uploaded to #{upload_path}"
      system %Q|git add #{upload_path}|
      author = session[:commit_author] = (params[:commit_author] || '').gsub(/[^\w@<>. ]/, '') 
      cmd = %Q|git commit --author='#{author}' -m 'added #{filename}' #{upload_path}|
      logger.debug cmd
      res = system cmd
    end
    def self.read(path)
    end
    def self.update(path, content, edit_message, author)
      edit_message ||= "unspecified edit"
      edit_msg_file = Tempfile.new('commit-message')
      edit_msg_file.write(edit_message) # we write this message to a file to protect against shell injection
      edit_msg_file.close
      File.open(path, 'w') {|f| f.write(content)}
      system %Q|git add #{path}|
      res = system %Q|git commit --author='#{author}' --file #{edit_msg_file.path} #{path}|
    end
    def self.delete(path, author)
      `git rm #{path}`
      res = system %Q|git commit --author='#{author}' --file #{edit_msg_file.path} #{path}|
    end
  end
end