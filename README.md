# AMAT EXAM

A mock exam creator for the Basic Canadian Amateur Radio Exam.

This is a study aid. Self-testing and recall practice are some of the bes
ways to help build your memory.

You can print the exam and take it under a time limit if you want to simulate
a real exam. Course instructors can use this to help their classes practice
test-taking or exam-taking.

## Requirements

  1. `ps2pdf`
  2. `amat_basic_quest.zip` from the [Canadian govt. site](https://www.ic.gc.ca/eic/site/025.nsf/eng/h_00004.html). You do not need to extract this, just leave it next to the generator.

## Usage

To generate a random set of 20 questions:

```
./generate.sh
```

### Arguments

  1. `-n QUESTION_COUNT` lets you choose how many questions are on the exam. 
     `QUESTION_COUNT` must be an integer between 1 and 1,000.

## Bugs/Limits

  1. It sometimes includes questions which rely on the multiple question
     choices. I'll add a "banned questions" lists in a future version, but for
     now, generate a new exam.

  2. There's only one question per page. I'll make a later version put 2 or 3
     questions on one page.

  3. There's no way to change the output location. I'll add args in a later
     version.

  4. No page numbers. It can be hard to tell if you've got all of the pages
     printed. I'll add page numbers in a later version.

  5. It doesn't match the real exam question distribution! Yup. I might fix
     this in a later version, or give the option to "switch things up"

## FAQ

### Why don't the prompts show up?

This is to help build memory. Recalling without a cue is more difficult, but
helps you better build your memory.

### Can you make the prompts show up?

Feature for the future!

### What if I want to study just one question category?

Future feature!
