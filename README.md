# instagram-creator-studio-automator
Used for automated scheduling in instagram's creator studio using selenium and date ranges. **Use at your own risk.**

## How to use

To install, use

```unix
git clone https://github.com/k1tsu/instagram-creator-studio-automator.git
cd ./instagram-creator-studio-automator
bundle
```

Then to use

```ruby run.rb```

This will bring up a series of inputs that you need to enter. Your facebook password/username are not saved, see [login.](https://github.com/k1tsu/instagram-creator-studio-automator/blob/c2718d89b5ab0f5a56a94a40035113e824b57af3/action.rb#L13-L14) 
An example input:
```
facebook username
>test            
facebook password
>test
start date (format:day,month,year)
>01,01,2021
end date (format:day,month,year)
>08,01,2021
times in 24 hour format (format:time1,time2,time3,...)
>01:00,02:00,03:00
account-name
>test
file-diretory
>~/Full/Path/To/Directory/
caption
>test
```







