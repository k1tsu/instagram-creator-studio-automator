require 'watir'
require 'benchmark'

def format_time(time)
    
    return [time[0], time[2], time[3][0]]

end

def login(browser, fbcred_username, fbcred_password) 
    browser.goto("https://business.facebook.com/creatorstudio/")
    browser.div(role: "none").click
    browser.text_field(id: "email").set(fbcred_username)
    browser.text_field(id: "pass").set(fbcred_password)
    browser.button(type: "submit").click
    browser.refresh
    browser.div(id: "media_manager_chrome_bar_instagram_icon").click
end


def create_post(browser, image_dir, date, time, orientation, index, caption)

    puts "creating post: #{index}"
    browser.div(text: "Create Post").click
    browser.strong(text: "Instagram Feed").click
    puts "  under #{account}"
    browser.div(text: account).click

    sleep(0.5)

    puts "adding content: #{image_dir}"
    browser.elements(text: "Add Content")[1].click
    browser.file_field(accept: "video/*, image/*").set(image_dir)
    until browser.div(class: "_6eqx").text == "100%"
    end

    puts "  content finished loading, cropping to #{orientation}"
    browser.div(title: "Crop Media").click
    browser.div(text: orientation).click

    puts "  saving content"
    browser.div(text: "Save").click

    puts "setting schedule"
    browser.elements(class: "_271k")[2].click
    browser.div(text: "Schedule").click

    puts "  setting date"
    browser.text_field(placeholder: "mm/dd/yyyy").click
    browser.text_field(placeholder: "mm/dd/yyyy").send_keys :backspace
    browser.text_field(placeholder: "mm/dd/yyyy").send_keys date
    browser.text_field(placeholder: "mm/dd/yyyy").send_keys :enter

    puts "  setting time"
    browser.elements(role: "spinbutton").to_a.each_with_index do |x, index|
        x.click
        x.send_keys(time[index])
    end

    puts "setting caption"
    sleep(0.5)
    browser.div(text: "Write your caption...").click
    browser.div(text: "Write your caption...").element.send_keys caption
    
    browser.div(text: "Schedule").click
    puts "finished"
    browser.elements(class: "_6x5h").each do |x|
        x.click
    end
    browser.refresh

end



