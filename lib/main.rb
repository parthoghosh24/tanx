require "gosu"

root_dir = File.dirname(__FILE__)
required_pattern=File.join(root_dir,'**/*.rb')
@failed = []

Dir.glob(required_pattern).each do |file|
  next if file.end_with?('/main.rb')
  begin
    require_relative file.gsub("#{root_dir}/",'')
  rescue
    @failed << file
  end
end

@failed.each do |file|
  require_relative file.gsub("#{root_dir}/",'')
end

$window = GameWindow.new
GameState.switch(MenuState.instance)
$window.show
