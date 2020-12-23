require_relative "logic"
require_relative "action"

attrs = []
questions = [
    "facebook username",
    "facebook password",
    "start date (format:day,month,year)", 
    "end date (format:day,month,year)", 
    "times in 24 hour format (format:time1,time2,time3,...)",
    "account-name",
    "file-diretory",
    "caption"
]

questions.each do |q|

    puts q
    print(">")
    attrs << gets.strip

end

start_day, start_month, start_year = attrs[2].split(",")
end_day, end_month, end_year = attrs[3].split(",")
times = attrs[4].split(",")

puts attrs


queue = EmpQueue.new(
    Time.new(start_year, start_month, start_day, "+00:00"), 
    Time.new(end_year, end_month, end_day, "+00:00"), 
    times, 
    attrs[5], 
    attrs[6]
)
queue.format
puts queue.generate

browser = Watir::Browser.new
login(browser, attrs[0], attrs[1])

total_time = Benchmark.measure do 
    queue.generate.each_with_index do |t, index|
        day = t.keys[0]
        p day
        t.values.flatten(1).each do |hour|
            h = hour.to_a[0]
            p h
            time = Benchmark.measure { create_post(browser, File.expand_path(h[1].keys[0]), day, format_time(h[0]), h[1].values[0], index, caption) }
            puts "done in: #{time}"
        end

    end

end
queue.cleanup()
puts total_time