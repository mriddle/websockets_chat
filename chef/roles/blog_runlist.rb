name "blog_runlist"
description 'blog stack'
run_list(
  "recipe[nginx]",
  "recipe[capistrano]",
  "recipe[rails]"
)