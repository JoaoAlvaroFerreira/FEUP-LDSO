# How to Contribute

This document lays out all the contribution guidelines that must be followed by everyone working on the repository.

## Branch organization

### `master`

The stable release branch. It is generally only updated at the end of each sprint. We should be able to release a new minor version from the tip of `master` at any time.

### `develop`

The development branch. It is an unstable branch, but only minor changes directly to `develop` are permitted, e.g., small edits to `README` or other miscellaneous text files, fixing typos in comments, etc.. All other changes should follow the workflow outlined below.

## Development workflow

Submit all changes via the issue & merge request procedure.

The core team is monitoring for merge requests. We will review your merge request and either merge it to `develop`, request changes to it, or close it with an explanation.

1. **File an issue with a detailed summary of the changes that you plan to make to the project**.

   Choose and fill out the proper issue template for the type of change you wish to make. There are some templates to choose from:

   - **Feature**: this should be used for suggesting new features (user stories) that should be implemented in the end product.
   - **Tech**: this should be used for suggesting work to be done on any of the technical aspects of the project, including reusable components, writing documentation, configuring the database, devops, etc..
   - **Bug**: this should be used for reporting (reproducible) bugs found.

   Writing a thorough description for your issue is crucial as it helps every developer understand what must be done and (hopefully) why. Please take your time making these details clear. Also, you should assign the proper labels to your issue - this saves others time.

   If there is already an open issue that addresses whatever you wanted to work on, feel free to contribute to its corresponding branch, after discussing with the current assignees (if any) to make sure it could use your help.

2. **Create a merge request and branch linked to that issue**.

   Use the GitLab interface on the issue page to automatically create a merge request and branch for that particular issue. For instance, for an issue with number "#x" titled "Some issue", the GitLab suggested branch name will be `x-some-issue`. This is the branch that should be created and worked on. The source branch should always be `develop`.

   The merge request title should remain prefixed with a "WIP:" (Work In Progress)as long as the work is still underway.

3. **Check out and begin working on the newly created branch**, committing any changes you've made along the way.

   See [the section on commits](#commits) for how you should think about committing to this project.

   Feel free to participate in and keep track of the discussion for that merge request.

4. **Merge the current `develop` branch into your issue branch**, when you have considered the work finished.

   You must fix any eventual merge conflicts that arise. Merge conflicts are a responsibility of the original commiter(s), not the reviewer(s).

   You can then remove the "WIP:" prefix from your merge request title, letting the team know the work is ready to be reviewed. Optionally, you may assign project maintainers to review the merge request.

   At this stage, you should change the label of the _issue_ to `In Review`, and remove the `Doing` label. (It is fine to keep the labels of the merge request as-is)

5. **Wait for someone to review your merge request**.

   Each merge request requires the approval of two different maintainers. Depending on the review, you will either be required to make further changes or your work will be accepted. Your merge request can also be rejected (closed) entirely, if the work is not satisfactory.

   Upon approval, any project maintainer can automatically merge the issue branch into `develop`. However, merge requests should never be squashed into one commit.

6. **Your work has been merged into `develop`**.

   This should conclude work on that particular issue. You may then delete the source branch for that particular merge request.

## Commits

> A project’s long-term success rests (among other things) on its maintainability, and a maintainer has few tools more powerful than his project’s log. It’s worth taking the time to learn how to care for one properly. What may be a hassle at first soon becomes habit, and eventually a source of pride and productivity for all involved.
>
> &mdash; <cite>Chris Beams</cite>, [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)

Read the full article quoted and linked above. It lays out the practices that should be followed when submitting commits to this project.

Linked in the above article is another article about the concept of "atomic commits", which you should also read and adopt the practices described therein.

> The common thought with those new to source control is to commit “at the end of the work day”, or “whenever I feel like it”, or whenever a batch of fixes are complete. Avoid those pitfalls and consider what an “atomic” block of work is and make a commit only when that is complete. It may make your commit history more verbose, but in the end it will make your overall project a lot more flexible for bug fixes, feature migrations, and rollbacks.
>
> &mdash; <cite>Sean Patterson</cite>, [Keep Your Commits "Atomic"](https://www.freshconsulting.com/atomic-commits/)
