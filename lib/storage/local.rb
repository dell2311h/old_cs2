module Storage
  class Local < Storage::Base
    def download(location, destination)
      copy("#{@params[:base_path]}/#{location}", destination)
    end

    def upload(location, destination)
      copy(location, "#{@params[:base_path]}/#{destination}")
    end

    def delete(location)
      File.delete("#{@params[:base_path]}/#{location}")
    end

    def update(location, destination)
      delete(destination)
      copy(location, destination)
    end

    def file_exist?(location)
      File.exist?("#{@params[:base_path]}/#{location}")
    end

    private
      def copy(location, destination)
        FileUtils.mkpath(File.dirname(destination))
        FileUtils.cp(location, destination)
      end
  end
end
