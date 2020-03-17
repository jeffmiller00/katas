# Root Insurance Coding Challenge

The problem statement can be found [here](https://gist.github.com/dan-manges/1e1854d0704cb9132b74). Generally, I tried to add functionality that was requested and logical extensions without going too deep (balancing basic functionality with [YAGNI](https://martinfowler.com/bliki/Yagni.html)).

## Files
 - **app/trip_log.rb**
   - I think there's an argument that this file would be more fleshed out if there wasn't a requirement to run the code directly with a `ruby` command on the command line.
   - Since the above 'requirement' is actually a suggestion, we could probably refactor all of the logic from `process_data_file.rb` into here and create rake tasks to run the example.
 - **app/trip.rb**
   - This contains a pretty straightforward class to hold all the logic for creating and calculating values for individual trips.
 - **app/driver.rb**
   - Driver.rb contains both the logic for drivers and their associated trips, but also to manage the collection of drivers.
   - The logic for the collection of drivers could be separated out into a specific model, but I chose to use class methods & variables because per the requirements we are not expected to persist these objects to db/disk and this structure was more "Rails-y" and resembled ActiveRecord calls to developers using the "Driver" class. For example, we have Driver.find, Driver.create and a Driver.all method could easily be implemented.

## Testing
Generally I don't like to go overboard testing and focus on business logic only. There are some tests where I'm *essentially* testing the "plumbing" mostly for demonstration.
You can run the full test suite with the following command: `ruby -Iapp -Ispec -rrspec/autorun ./spec/*_spec.rb`

## Todo
 - I could better define the interface between the hash passed
   between `trip_log.rb` and `process_data_file.rb` or refactor it
   entirely as mentioned above
 - There could be more inline comments to explain decisions closer to the code. I'm relying on this README and my commit messages at the moment.
 - Depending on if the input file is critical or if this code is primarily for parsing events structured like one line of the file, I should add more tests that actually read in the file and process it all together. This would include accounting for scenarios where a line in the middle of the file fails either validation or another error (command not found, can't find driver, etc) and processes the rest of the data.
