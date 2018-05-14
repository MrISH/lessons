# README

## Initial thoughts
Wish to use some new, recently discovered gems, as they introduce a different approach to things than the default Rails way.

- dry-rb 
    + `http://dry-rb.org/`
    + dry-types
    + dry-transaction / dry-monads
- rom-rb
    + `http://rom-rb.org/`

Intent is to implement the project so that the code is reusable, replaceable, easily tested, easily understood and accessible to any developer that views the code.

##### To that end:

- Write clear, clean tests to inform how to write the code (TDD)
- Use service objects for "doing" anything with data
    + use `dry-transaction` / `dry-monad`, for clearer success/failure handling
- Use `dry-types` to implement type safety
- Version the API using a URL based versioning scheme


## Background

- Company X is developing a new app for student education. 
- Students complete lessons and their progress is recorded.
- Each lesson has 3 parts - 1, 2 and 3. There are 100 lessons in total.

### Implementation
#### Models
    - Student { name: String }
    - StudentLessonProgress { student_id: Int, lesson_id: Int, part_id: Int }
    - Lesson { name: String }
    - LessonPart { lesson_id: Int, name: String }
#### Seed: `rake db:seed`
    - 100 Lessons - L1..L100
    - 3 Parts for each lesson - P1..P3




### Part 1

#### Description
    Generate a rails app that persists students and their progress.
    Define routes for:
    a) setting a student's progress - progress should consist of a lesson and part number.
    b) returning a JSON representation of a student and their associated progress.

#### Assumptions
    - "persists students and their progress" implies the action of creating a student, and setting their lesson progress. Therefore at this point I will build an API endpoint for creating a student, with appropriate success/fail responses
#### Implementation
    - Restrict routes to json format
    - Use convention of `API::V1::StudentLesson` for versioning of API (and therefore using namespaces in `routes.rb`)




### PART 2

#### Description
    Teachers have classes containing number of students.
    a) Add a teacher model that is related to students
    b) Create a reports page for a teacher to view progress all of their students.

#### Implementation
    - A student may (at some point) be part of mutiple classes, therefore we'll use a join table to model the relationship
    - Utilise the existing API for retrieving student progress. Adjust API to allow for filtering by teacher and/or class, so it can respond to the reports page (a teacher may have many classes?)
    - Using the StudentLesson API and implementing the report page as a client "app" will allow for much better flexibility and scalability by allowing the entire report section to be run on one or more dedicated servers.
    - implement a super dumb authorisation system - user/pass saved in session to match user/pass stored in teacher record. Will allow for different teachers to view only their own classes / students
##### Models
    - Teacher { name: String }
    - Classroom { teacher_id: Int }
    - StudentClassroom { classroom_id: Int, student_id: Int }
    - Student { first_name: String, last_name: String }
##### Controllers
    - ReportsController
        + `def students;end`
        + table view of all students, paginated, filter on name, lesson / part(?)




### PART 3

#### Description
    Calculating progress
    a) add a method for updating student progress - this should verify that the
    student is only able to complete the next part number in sequence e.g.
    L1 P1, L1 P2, L1 P3, L2 P1, L2 P2 etc

#### Implementation
    - "setting student progress" should find a student by ID, and set their progress, if included on request. Action should return appropriate success/fail response if student, or lesson progress is not found.
    - Both "setting" and "getting" progress will return the same data: student attributes, and their lesson progress, for uniformity in general, and so the API consumer can expect the same format from both endpoints



## Development Setup
To get development environment set up
```
    git clone git@github.com:MrISH/lessons.git
    cd lessons/
    gem install bundler --no-ri --no-rdoc
    bundle install
    rake db:create && rake db:migrate && rake db:seed
    yarn add axios
    yarn add react-scripts
    rails s -p 3001
    yarn start
```

- Teachers report will be available at `http://localhost:3000`
- API can also be accessed at `http://localhost:3000/api`
- ie. `http://localhost:3000/api/v1/students/report.json?teacher_id=1`

## Tests
Run rspec specs
`bundle exec rspec -fd`


## Wrap up

### Part 1
    Initially implemented as a full Rails app, but rebuilt using `--api` flag 
    to reduce overhead and keep the API solely as an API.
    Added API endpoints to create and update students, along with their lesson 
    progress.
    Utilised `dry-transcation` gem to create service objects to handle data 
    changes. This was intended to keep the controller and model code succinct 
    and relevant, and allow for easier developemnt and refactoring in the 
    future. This was a brand new gem for me, which I wished to learn to use, 
    as I liked the idea behind it.
    I had started looking into using `rom-rb` and `dry-types`, as they also 
    were of interest to me to learn, but they required quite a large 
    investment of time, which I did not have. I am even more inclined to learn 
    them after looking into them during this project.
    Rspec test coverage created for both valid and invalid requests
    Model specs are not complete due to time contstraints.

### Part 2
    Opted to create a client app to keep the Rails API an API, and because I 
    was interested in the process of doing this.
    Arbitrarily chose ReactJS, as I have no experience in client side apps, 
    and that came as popular.
    This necessitated learning ReactJS, and how to run it within a Rails app.
    No tests were created for the client app itself, and minimal tests for the 
    API endpoint that drives the report page.
    Intended to allow report to swtich between teachers, pagination of 
    students list, and filtering on classrooms, lesson, 
    and lesson part, however the learning curve was significant, and time was
    short already, so this was parked.
    API endpoint has functionality to filter by a teacher, and a classroom, or 
    return all students for a teacher.
    Missing "classroom" column from report due to time contraints.

### Part 3
    Added method to `Student` model `progress_to_lesson(lesson:, lesson_part:)`, 
    called from within `UpdateStudentLessonProgress`. This method will only 
    allow a student to progress to the next lesson or lesson part after their 
    current lesson/part.
    The code is first implementation, and would do well with a refactor to 
    clean it up and make it more readable. It also needs tests written for it.


### Summary
    I would say this project began well, with a reasonable amount of time 
    spent building the app structure, investigating new gems and determining 
    which would be worth learning and using and which ones to leave. I made 
    some assumptions around the wording of the project requirements, and so 
    included the create/update student API endpoints.
    Implementing the report as a client app was a large task, which I knew 
    from the outset, however I wished to not use Rails for views, and keep it 
    as an API only application. In doing so I ran out of time to add complete 
    tests for the report API and the lesson progression guard in Step 3.
    I probably overly complicated the lesson / lesson part relationship, where 
    this could have resided in a single model. I was thinking of these models 
    as potentially containing the lesson / lesson part content as well, and 
    decided to make them separate models/tables.
