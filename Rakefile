require 'yaml'
require 'fileutils'
require 'pp'


DOTFILES_HOME = ENV['HOME']
DOTFILES_ROOT = File.dirname(__FILE__)
CONFIG_PATH = File.join(DOTFILES_ROOT, 'config.yml')
CONFIG = YAML.load_file(CONFIG_PATH)
VSCODE_EXT = YAML.load_file(File.join(DOTFILES_ROOT, 'vscode', 'extensions.yml'))


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

    if name == "lfm"
      link_path = File.join(DOTFILES_HOME, ".config/", name)
      system "mkdir #{DOTFILES_HOME}/.config" unless File.directory? "#{DOTFILES_HOME}/.config"
    end

    # check for directory and remove it
    system "rm -rf #{link_path}" if File.directory?(link_path)
    system "unlink #{link_path}" if File.exists?(link_path)
    system "ln -vsf #{path} #{link_path}"
  end
end


task :binfiles do
  files = CONFIG['binfiles']
  files_dir = File.join(DOTFILES_ROOT, 'bin')

  FileUtils.mkdir_p("#{DOTFILES_HOME}/bin")

  files.each do |name|
    path = File.join(DOTFILES_ROOT, 'bin', name)
    link_path = "#{DOTFILES_HOME}/bin/#{File.basename(name)}"

    system "unlink #{link_path}" if File.exists?(link_path)
    system "ln -vsf #{path} #{link_path}"
  end
end


# helpers
def package_manager_task(version)
    target_dir = File.join(ENV['HOME'], 'Library', "Application Support",
                          "Sublime Text #{version.to_s}")
    target_path = File.join(target_dir, 'Package Control.sublime-package')
    if File.exists?(target_path)
      puts "Sublime Package Control already installed! :)"
      exit
    end

    Dir.chdir(target_dir) do
      system "wget https://sublime.wbond.net/Package%20Control.sublime-package -O 'Package Control.sublime-package'"
    end
end


def settings_task(version)
    sublime_dir = File.join(ENV['HOME'], 'Library', "Application Support",
                          "Sublime Text #{version.to_s}")

    source_path = File.join(DOTFILES_ROOT, 'sublime_text2', 'Preferences.sublime-settings')
    source_sidebar_path = File.join(DOTFILES_ROOT, 'sublime_text2', 'SoDaReloaded Dark.sublime-theme')

    target_path = File.join(sublime_dir, 'Packages', 'User', 'Preferences.sublime-settings')
    target_sidebar_path = File.join(sublime_dir, 'Packages', 'User', 'SoDaReloaded Dark.sublime-theme')


    # Check on the installed sublime_text2
    if !File.exists?(sublime_dir)
      FielUtils.mkdir_p(sublime_dir, 'Packages/User')
    end


    system "unlink \"#{target_path}\"" if File.exists?(target_path)
    system "ln -vsf \"#{source_path}\" \"#{target_path}\""


    # Install Material Theme
    Dir.chdir(File.join(sublime_dir, 'Packages')) do
      if !File.exists?("Theme - Soda")
        system 'git clone https://github.com/Miw0/SoDaReloaded-Theme.git "Theme - SoDaReloaded"'
      else
        puts "SoDaReloaded theme is already installed. Skipping."
      end
    end

    # Install sidebar config
    system "unlink \"#{target_sidebar_path}\"" if File.exists?(target_sidebar_path)
    system "ln -vsf \"#{source_sidebar_path}\" \"#{target_sidebar_path}\""
end

def themes_task(version)
    repo = 'git://github.com/daylerees/colour-schemes.git'
    target_dir = File.join(ENV['HOME'], 'Library', "Application Support",
                          "Sublime Text #{version.to_s}")
    target_path = File.join(target_dir, 'Packages', 'Custom Themes')

    if !File.exists?(target_path)
      FileUtils.mkdir_p(target_path)
    end

    system %[cd '#{target_path}' && git clone #{repo}]
    system %[cd '#{target_path}'/colour-schemes && git pull]
end


def vscode_settings_task
    source_path = File.join(DOTFILES_ROOT, 'vscode', 'settings.json')
    vscode_dir = File.join(ENV['HOME'], 'Library', 'Application Support', 'Code')
    target_path = File.join(vscode_dir, 'User', 'settings.json')

    # Check on the installed sublime_text2
    FileUtils.mkdir_p(vscode_dir) unless File.exists?(vscode_dir)

    if File.exists?(target_path)
      system "unlink \"#{target_path}\""
    else
      system "ln -vsf \"#{source_path}\" \"#{target_path}\""
    end  
end

def vscode_install_extensions_task
  extensions = VSCODE_EXT['extensions']
  extensions.each do |ext|
    system "code --install-extension #{ext}"
  end
end


namespace :sublime3 do

  task :package_manager do
    package_manager_task 3
  end

  task :settings do
    settings_task 3
  end

  task :themes do
    themes_task 3
  end

end

namespace :vscode do
  task :settings do
    vscode_settings_task
  end
  
  task :extensions do
    vscode_install_extensions_task
  end
end

task :install do
    Rake::Task['dotfiles'].invoke
    Rake::Task['binfiles'].invoke
end
