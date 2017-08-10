module Gundam
  module Commands
    module Shared
      module FileHelper
        def create_file(filename, text = nil)
          File.join(Gundam.base_dir, 'files', filename).tap do |filepath|
            FileUtils.mkdir_p(File.dirname(filepath))

            if text.to_s.empty?
              FileUtils.touch(filepath)
            else
              File.write(filepath, text)
            end
          end
        end

        def edit_file(filepath)
          system("$EDITOR #{filepath}")
          File.read(filepath)
        end

        def file_timestamp
          Time.now.utc.strftime('%Y%m%d%H%M%S')
        end
      end
    end
  end
end
