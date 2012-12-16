%w{build-essential binutils-doc autoconf flex bison ruby-dev ruby1.9.1-dev}.each do |pkg|
  package pkg do
    action :install
  end
end
