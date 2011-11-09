module Fredit
  class Backend
    def self.create(path)
      raise StandardError("Subclass me and override this method")
    end
    def self.read(path, author)
      raise StandardError("Subclass me and override this method")
    end
    def self.update(path, content, edit_message, author)
      raise StandardError("Subclass me and override this method")
    end
    def self.upload(uploaded_file, author)
      raise StandardError("Subclass me and override this method")
    end
    def self.delete(path)
      raise StandardError("Subclass me and override this method")
    end
  end
end