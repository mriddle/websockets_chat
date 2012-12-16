Capistrano::Configuration.instance(:must_exist).load do
  def dirs_changed? *dirs
    return true unless remote_file_exists? "#{current_path}/REVISION"
    from = source.next_revision(current_revision)
    capture("cd #{latest_release} && #{source.local.log(from)} #{dirs.join(' ')} | wc -l").to_i > 0
  end

  def remote_file_exists?(full_path)
    'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
  end

  def remote_process_exists?(pid_file)
    return false unless remote_file_exists? pid_file
    capture("ps -p $(cat #{pid_file}) ; true").strip.split("\n").size == 2
  end
end