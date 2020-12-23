require 'date'
require 'fastimage'

class EmpQueue

    def initialize(start_date, end_date, times, accountname, dir)

        @accountname = accountname
        @start_date = Time.new(start_date.year, start_date.month, start_date.day, "0:00")
        @end_date = end_date
        @times = times

        dur = (@end_date - @start_date)
        @time_attrs = {
            days: dur/86400,
            weeks: (dur/86400)/7,
            months: ((dur/86400)/7)/4
        }

        @dir = dir

        @spread = (times.count*@time_attrs[:days]).round
        @generated = false

        @img_locations = {}

        @used = []
        @needed = (@time_attrs[:days] * times.count) 

    end

    def format

        filenames = Dir.children(@dir)
        sizes = filenames.map {|img| {img => FastImage.size("#{@dir}/#{img}")}}
        keep = sizes.map {|x| [x.values[0][0] >= 1080, x.values[0][1] >= 1080]}
        keep.each_with_index do |file, index|

            if file.count(false) == 2
                `rm #{dir}/"#{filenames[index]}"`
            end
        end

        if Dir.children(@dir).count >= @needed

            size_hash = {}
            sizes.each do |hash|
                if hash.values[0][0] > hash.values[0][1]
                    size_hash[hash.keys[0]] = "Landscape"
                elsif hash.values[0][0] < hash.values[0][1]
                    size_hash[hash.keys[0]] = "Vertical"
                else
                    size_hash[hash.keys[0]] = "Square"
                end
            end

            @img_locations = Dir.children("#{@dir}").map {|x| {"#{@dir}/#{x}"=>size_hash[x]}}
            @img_raw = Dir.children("#{@dir}").map {|y| "'#{y}'"}
            @generated = true
        else
            warn("Not enough images! (have: #{Dir.children(@dir).count}, need: #{@needed})")
        end
    end

    def generate 

        if @generated
            counter = 0
            b = (0..@time_attrs[:days]).to_a.map {|x| @start_date + (86400*x)}
            formatted = []
            b.each_with_index do |x|
                d = [] 
                @times.each do |b| 
                    d << {DateTime.parse(b).strftime("%l : %M %p").split(" ") => @img_locations[counter]}
                    counter += 1
                    @used << @img_raw[counter] 
                end
                formatted << {x.strftime("%m/%d/%Y") => d.delete_if {|k| Time.new(x.year, x.month, x.day, k.keys[0].join("")).to_datetime.past?}}
            end
            formatted.delete_if {|x| x.values.flatten === []}
        else
            raise "images have not been formatted"
        end

    end

    def cleanup

        new_dir = "./images/#{@accountname}_used"
        Dir.mkdir(new_dir) unless Dir.exist?(new_dir)
        @used.each do |b| 

            `mv -i #{@dir}/#{b} #{new_dir}/#{b}`

        end
        

    end

end
