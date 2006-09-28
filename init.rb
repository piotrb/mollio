# Include hook code here

def symlink_helper(src, dst)
  base_dir = File.dirname(dst)
  base_name = File.basename(dst)
  Dir.chdir("#{RAILS_ROOT}/#{base_dir}") {
    unless File.exist?(base_name)
      FileUtils.ln_s(src, base_name)
    end
  }
end

symlink_helper("../vendor/plugins/mollio/public", "public/mollio")
symlink_helper("../../../vendor/plugins/mollio/views/layouts/admin.rhtml", "app/views/layouts/admin.rhtml")
