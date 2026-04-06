import datetime

# Read input
day, month, year = map(int, input().split())

# Create a date object
date_obj = datetime.date(year, month, day)

# Get the day name and convert to uppercase
print(date_obj.strftime("%A").upper())
