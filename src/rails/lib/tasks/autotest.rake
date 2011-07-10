task :autotest do
  sh("export AUTOFEATURE=true; autotest")
end