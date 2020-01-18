require 'fileutils'

DATE_4_DIGIT_YR_REGEX = /\d{4}(-|_)\d{2}(-|_)\d{2}/
DATE_2_DIGIT_YR_REGEX = /\d{2}(-|_)\d{2}(-|_)\d{2}/

PRAYER_PRAISE_REGEX = /^(prayer\sand\spraise).*(\.txt)\z/
SERMON_REGEX = /^(sermon).*(\.txt)\z/
MENS_GROUP_REGEX = /^(mens\sgroup).*(\.txt)\z/
BIBLE_STUDY_REGEX = /^(bible\sstudy).*(\.txt)\z/
PERSONAL_BIBLE_STUDY_REGEX = /^(personal\sbible\sstudy).*(\.txt)\z/

DO_NOT_MOVE_LIST = %w(.ruby-version extract_new_notes.rb .ds_store ./processed processed .idea README.md .plist .gitignore .git com.matgreten.rocketbooknotes.plist)

def append_to_list_file(input_file, file_name)
  puts "|||||| Writing to '#{file_name}.md' file from '#{input_file}'."

  File.open("../../Walk/notes/#{file_name}.md", "a") do |file|
    File.open(input_file) do |input_file_contents|
      input_file_contents.each_line do |line|
        file << "- [ ] #{line}"
      end
    end
  end
end

def append_to_ongoing_project(input_file, file_name)
  puts "Writing to '#{file_name}.md' file from '#{input_file}'."

  File.open("../../Walk/notes/#{file_name}.md", "a") do |file|
    File.open(input_file) do |input_file_contents|
      file << "\n"
      input_file_contents.each_line do |line|
        file << "#{line}"
      end
    end
  end
end

def new_file_name(name, date)
  "#{name} #{date}.md"
end

def move_to_sermons(input_file)
  input_file_name = input_file.downcase

  recorded_date = input_file_name[DATE_4_DIGIT_YR_REGEX]
  recorded_date = "20#{input_file_name[DATE_2_DIGIT_YR_REGEX]}" if recorded_date.nil?

  name = ""

  if input_file_name =~ PRAYER_PRAISE_REGEX
    name = "Prayer & Praise"
  elsif input_file_name =~ SERMON_REGEX
    name = "Sermon"
  elsif input_file_name =~ MENS_GROUP_REGEX
    name = "Men's Group"
  elsif input_file_name =~ BIBLE_STUDY_REGEX
    name = "Bible Study"
  elsif input_file_name =~ PERSONAL_BIBLE_STUDY_REGEX
    name = "Personal Bible Study"
  end

  file_name = new_file_name(name, recorded_date)

  puts "Creating '#{file_name}' from file from '#{input_file}'."

  sermons_path = "../../Walk/notes/Sermons/"
  file_contents = ""
  if File.file?(sermons_path + file_name)
    puts "File already exists. Skipping."
  else
    file_contents += "# " << " #{name}\n\n" << recorded_date
  end

  # Add input_file contents to the title created above
  File.open(input_file) do |input_file_contents|
    new_data = input_file_contents.read
    file_contents += new_data
  end

  File.open(sermons_path + file_name, "w") do |file|
    file << file_contents
  end
end

Dir.each_child(".") do |file|
  file_name = file.downcase

  if file_name =~ PRAYER_PRAISE_REGEX || file_name =~ SERMON_REGEX ||file_name =~ MENS_GROUP_REGEX || file_name =~ BIBLE_STUDY_REGEX || file_name =~ PERSONAL_BIBLE_STUDY_REGEX
    move_to_sermons(file)
  end

  if file.downcase =~ /^(books).*(\.txt)\z/
    append_to_list_file(file, "Books/Books")
  end

  if file.downcase =~ /^(music).*(\.txt)\z/
    append_to_list_file(file, "Music")
    end

  if file.downcase =~ /^(movies).*(\.txt)\z/
    append_to_list_file(file, "Movies")
  end

  if file.downcase =~ /^(podcast).*(\.txt)\z/
    append_to_list_file(file, "Podcast")
  end

  if file.downcase =~ /^(things to learn).*(\.txt)\z/
    append_to_list_file(file, "Learning")
  end

  if file.downcase =~ /^(ideas).*(\.txt)\z/
    append_to_list_file(file, "Ideas")
  end

  if file.downcase =~ /^(app ideas).*(\.txt)\z/
    append_to_list_file(file, "App Ideas")
  end

  if file.downcase =~ /^(share with kate).*(\.txt)\z/
    append_to_list_file(file, "Share with Kate")
  end

  if file.downcase =~ /^(baby monitor).*(\.txt)\z/
    append_to_ongoing_project(file, "Baby Monitor Project")
  end

  if file.downcase =~ /^(strength app).*(\.txt)\z/
    append_to_ongoing_project(file, "Strength App")
  end

  if file.downcase =~ /^(quotes).*(\.txt)\z/
    append_to_ongoing_project(file, "Quotes")
  end

  today = Time.new
  processed_date = today.strftime("%F_%H-%M")
  unless DO_NOT_MOVE_LIST.include?(file)
    puts "Moving processed file: '#{file}' to ./processed/#{today}_#{file_name}."
    FileUtils.mv("./#{file}", "./processed/#{processed_date}_#{file_name}")
  end
end

# TODO: should we do any kind of formatting / format processing? Or leave that to be manual?
