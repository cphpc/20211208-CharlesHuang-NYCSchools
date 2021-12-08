# 20211204-CharlesHuang-NYCSchools

Hi, my name is Charles Huang and this is my solution to the NYC Schools coding challenge.

### Solution

I decided to show the list of high schools in two formats. One in a generic list view that groups the schools into sections by the cities in which they are located in. The second format is showing the schools within a map view where each school is an annotated pin on the map. For both solutions, you can click on the cell or pin and push to the SAT results controller.

Within the results controller, you'll find information regarding the school's name, total SAT takers, as well as the scores for each SAT type (reading, writing, and math). I wanted to show a bolder design for this view which is why I decided to show the scores in such a large and bold font. As well, I added a progress bar (score / 800) to show the scores graphically.

### Technical Decisions

I think the main technical decisions I had to make was mainly regarding the fetching, formatting, and caching of the school and SAT results data. I decided to cache the main school data within UserDefaults so that I can easily encode/decode the data upon app start. I didn't want to add any other libraries (Core Data, Realm, etc.) which I believe would over complicate the app. Saving a basic key-value dictionary within UserDefaults is both lightweight and serves its purposes for this project.

In terms of fetching and formatting the data, I wrote a network service class called SchoolService which utilizes the Combine library to get the necessary school and SAT results information and public back to the view model. Once the data has been fetched, I format the data so that it can be used by the list table view and map view accordingly.

Upon initial launch, the app will fetch both the school and SAT data. When both fetches has finished, I then format the data and reloat the table and map views. Any subsequent launch, the data will be returned from UserDefaults. I made a technical decision to not fetch the SAT results on the fly (as-in fetch when the user actually wishes to look at the data) because I wanted the view to be shown instataneously. 

I only made this decision because the SAT results was a finite set of data. If the data is any larger (all the schools in the US?) as well as dynamic (by year?) then I would most likely decide to fetch on the fly and store/cache it. Note, I did write the fetch results by school method but decided against using it.

### More Features and Improvements

One feature I would like to add would be a way to search for a specific school. Because of timing constraints, I chose to work on the map feature instead of the search feature. One optimization to look into would be making the map view more memory efficient. The map view seems to take quite a bit of memory so it would be worth-while to think of a way to optimize it.

### Testing

I added a suite of unit tests for both SchoolsViewModel and ResultsViewModel which should cover most of what's shown to the user. ResultsViewModel tests were more basic in that they verify that the SAT information was correct while the SchoolsViewModel tests were a bit more involved in terms of parsing, loading and saving data from UserDefaults. Given more time, we could also add more test for the different methods within SchoolsViewModel as well as asynchronous tests for SchoolService.

### Notes

For both the list and map views, I only included the schools that had valid SAT results. I found that some schools did not have corresponding SAT results and some also had an "s" result. I'm not sure what the "s" stands for but I left it out of the school lists. This ensures that every school on the list has associated SAT takes and scores.

This app supports both light and dark appearances. The reason why I chose to stick with mostly default text colors and fonts is so that it will be 100% compatible when switching between appearances. As well, I tested on small devices (iPhone SE) and large devices (iPad 11"). All iOS devices are supported as well. 
