module Gundam
  module Commands
    module Shared
      module FileHelper
        def create_file(filename)
          File.join(Gundam.base_dir, 'files', filename).tap do |filepath|
            FileUtils.mkdir_p File.dirname(filepath)
            FileUtils.touch(filepath)
          end
        end

        def write_file(filename, text)
          File.write(filename, text)
        end

        def open_file(filepath)
          system("$EDITOR #{filepath}")
        end

        def file_timestamp
          Time.now.utc.strftime('%Y%m%d%H%M%S')
        end
      end
    end
  end
end
