require 'fileutils'
require 'pp'


DOTFILES_HOME = ENV['HOME']
DOTFILES_ROOT = File.dirname(__FILE__)
CONFIG_PATH = File.join(DOTFILES_ROOT, 'config.yml')
CONFIG = YAML.load_file(CONFIG_PATH)


task :config do
  CONFIG.each_pair do |name, files|
    puts "#{name}:"
    files.each { |f| puts " -#{f}" }
  end
end



task :dotfiles do
  files = CONFIG['dotfiles']
  files_dir = File.join(DOTFILES_ROOT, 'dotfiles')

  files.each do |name|
    path = File.join(DOTFILES_ROOT, 'dotfiles', name)
    link_path = File.join(DOTFILES_HOME, ".#{name}")

    system "unlink #{link_path}" if File.exists?(link_path)
    system "ln -vsf #{path} #{link_path}"
  end
end


task :binfiles do
  files = CONFIG['binfiles']
  files_dir = File.join(DOTFILES_ROOT, 'bin')

  FileUtils.mkdir_p("#{DOTFILES_HOME}/bin")

  files.each do |name|
    path = File.join(DOTFILES_HOME, 'bin', name)
    link_path = "#{DOTFILES_HOME}/bin/#{File.basename(name)}"

    system "unlink #{link_path}" if File.exists?(link_path)
    system "ln -vsf #{path} #{link_path}"
  end
end


namespace :sublime do

  task :package_manager do
    target_dir = File.join(ENV['HOME'], '.config', 'sublime-text-2', 'Installed Packages')
    target_path = File.join(target_dir, 'Package Control.sublime-package')
    if File.exists?(target_path)
      puts "Sublime Package Control already installed! :)"
      exit
    end

    Dir.chdir(target_dir) do
      system "wget https://sublime.wbond.net/Package%20Control.sublime-package -O 'Package Control.sublime-package'"
    end
  end


  task :settings do
    source_path = File.join(DOTFILES_ROOT, 'sublime_text2', 'Preferences.sublime-settings')
    sublime_dir = File.join(ENV['HOME'], '.config', 'sublime-text-2')
    target_path = File.join(sublime_dir, 'Packages', 'User', 'Preferences.sublime-settings')


    # Check on the installed sublime_text2
    if !File.exists?(sublime_dir)
      FielUtils.mkdir_p(sublime_dir, 'Packages/User')
    end


    if File.exists?(target_path)
      system "unlink #{target_path}"
    else
      system "ln -vsf #{source_path} #{target_path}"
    end

    # Install Soda Theme
    Dir.chdir(File.join(sublime_dir, 'Packages')) do
      if !File.exists?("Theme - Soda")
        system 'git clone https://github.com/buymeasoda/soda-theme/ "Theme - Soda"'
      else
        puts "Soda theme is already installed. Skipping."
      end
    end
  end

  task :themes do
    repo = 'git://github.com/daylerees/colour-schemes.git'
    target_dir = File.join(ENV['HOME'], '.config', 'sublime-text-2')
    target_path = File.join(target_dir, 'Packages', 'Custom Themes')

    if !File.exists?(target_path)
      FileUtils.mkdir_p(target_path)
    end

    system %[cd '#{target_path}' && git clone #{repo}]
             system %[cd '#{target_path}'/colour-schemes && git pull]
    end
end

task :install do
    Rake::Task['dotfiles'].invoke
    Rake::Task['binfiles'].invoke
end
