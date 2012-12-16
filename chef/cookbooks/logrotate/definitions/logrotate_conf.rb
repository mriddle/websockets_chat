define :logrotate_conf, :frequency => "weekly", :rotate => '7' do
  include_recipe "logrotate"

  path = params[:path].respond_to?(:each) ? params[:path] : params[:path].split

  template "/etc/logrotate.d/#{params[:name]}" do
    source 'logrotate.erb'
    cookbook 'logrotate'
    mode "0644"
    owner "root"
    group "root"
    backup false
    variables(
      :path => path,
      :frequency => params[:frequency],
      :rotate => params[:rotate]
    )
  end
end

