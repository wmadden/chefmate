Dir.glob("./lib/tasks/**/*.rb").each do |file|
  require "./#{file}"
end