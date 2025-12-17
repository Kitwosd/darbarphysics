# Questions for User

1. **Package Name**: You mentioned the folder is misspelled as `durbar_physics` and the `pubspec.yaml` also uses `name: durbar_physics`. Do you want to keep this as is to avoid breaking existing setups/CI, or would you like me to plan a refactor to rename it to `durbar_physics` in the future?

2. **Next Steps**: You mentioned "we were working on setting up github... repo is empty right now". Since the CI/CD docs and workflows are present, is the immediate next step to initialize the git repo and push, or are there pending code changes/features (like the Video Player or Home UI refinements) that need to be finished first?

3. **Mock Data**: I see `MockHomeRepo` is currently wired up. Is there a plan/timeline for when the real backend (`HomeRepoImpl`) will be needed, or should we continue developing securely with the Mock setup for the foreseeable future?
