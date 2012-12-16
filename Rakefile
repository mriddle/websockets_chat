require_relative 'app/blog'

namespace :assets do

  desc "Compile all the assets"
  task :compile do
    ['application', 'vendor'].each do |asset|
      ['js', 'css'].each do |type|
        file_name = "#{asset}.#{type}"
        write_asset(file_name)
      end
    end
    compile_images
  end

  def compile_images
    Dir.glob('assets/images/*').each do |file_name|
      write_asset(File.basename(file_name))
    end
  end

  def write_asset(file_name)

    sprockets   = Blog.settings.sprockets
    asset       = sprockets[file_name]
    outpath     = File.join(Blog.settings.assets_path)

    asset_path  = Blog.settings.sprockets.find_asset(file_name)
    return unless asset_path.respond_to? :digest_path

    digest_path = asset_path.digest_path

    outfile     = Pathname.new(outpath).join(file_name)
    digest      = Pathname.new(outpath).join(digest_path)

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    asset.write_to(digest)
    asset.write_to("#{outfile}.gz")
    puts "successfully compiled #{file_name}", outfile, digest
  end

end