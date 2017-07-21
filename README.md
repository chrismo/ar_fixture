# What

This repo demonstrates my DIY pattern for ActiveRecord fixtures. See
also http://clabs.org/blog/DiyActiveRecordFixtures

# Why

factory_girl and machinist define DSLs that can be hard to debug if you
run into a case where the fixtures can't get setup properly. It's hard
to debug because these gems do all of their magic at runtime, so
stepping through the stack trace is ... challenging. These cases aren't
that common, but in working around these problems before, I've used a
pattern of setting up my own fixtures directly against the ActiveRecord
API. It's slightly more verbose, but usually looks the same as
factory_girl/machinist setups do, and will always be making the same AR
calls the production code would be making, so you don't have to suffer
through "Why won't factory_girl setup this association properly?!"

It's also easier to de-couple the fixtures from the test environment,
which can setup options for building out utilities for seeding your dev
database for different scenarios for exploratory testing, UI fidgeting,
etc.

Fixtures as a concept are great. The real value in these fixtures ends
up being the business logic for setting up different object graph
cases, and that work is the same regardless of whether or not you code
the fixtures against AR directly (my preference) or through an
additional API layer (factory_girl, machinist).

# To Do

Try out miniskirt, fabrication, others?
